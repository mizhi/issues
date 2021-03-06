defmodule Issues.GithubIssues do
  @user_agent [{"User-agent", "Foo foo"}]

  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end

  def handle_response({200, %HTTPoison.Response{body: body}}) do
    {:ok, Poison.Parser.parse!(body)}
  end

  def handle_response({status, %HTTPoison.Response{body: body}}) do
    {:error, Poison.Parser.parse!(response.body)}
  end
end
