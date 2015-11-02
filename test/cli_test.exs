defmodule CliTest do
  use ExUnit.Case

  import Issues.CLI, only: [ parse_args: 1,
                             sort_into_ascending_order: 1]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "three values returned if three arguments given" do
    assert parse_args(["user", "project", "42"]) == {"user", "project", 42}
  end

  test "default count is return if 2 arguments given" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end

  test "sort ascending orders in the correct way" do
    data = for value <- ["c", "b", "a"] do
      [{"created_at", value}, {"other_data", "xxx"}]
    end
    results = sort_into_ascending_order(data)

    created_times = for result <- results, do: result["created_at"]

    assert created_times == ~w{a b c}
  end
end
