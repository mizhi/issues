defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle command line parsing and dispatch
  """

  def run(argv) do
    argv |>
      parse_args |>
      process
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv,
                               switches: [ help: :boolean ],
                               aliases: [ h: :help ])

    case parse do
      {[help: true], _, _} ->
        :help

      {_, [user, project, count], _} ->
        {user, project, String.to_integer(count)}

      {_, [user, project], _ } ->
        {user, project, @default_count}

      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [ count | #{@default_count} ]
    """
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response
    |> sort_into_ascending_order
    |> Enum.take(count)
    |> Issues.TableFormatter.print_table_for_columns(["number", "created_at", "title"])
  end

  def decode_response({:ok,  response}) do
    response
  end

  def decode_response({:error, %{"message" => message}}) do
    IO.puts "Error fetching from github: #{message}"
    System.halt(2)
  end

  def sort_into_ascending_order(issue_list) do
    Enum.sort(issue_list, fn i1, i2 -> i1["created_at"] <= i2["created_at"] end)
  end
end
