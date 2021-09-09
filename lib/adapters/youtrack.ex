defmodule Slackyt.Adapters.YouTrack do
  @base_path Application.get_env(:slackyt, :secret)[:base_path]
  @token Application.get_env(:slackyt, :secret)[:token]

  @spec get_custom_fields(binary) :: map()
  def get_custom_fields(issue_id) do
    {:ok, response} =
      HTTPoison.get(
        @base_path <> "issues/" <> issue_id <> "/customFields/",
        [{"Bearer", @token}, {"content-type", "application/json"}],
        [{:params, %{"fields" => "id"}}]
      )

    {:ok, result} = Poison.decode(response.body)
    result
  end

  @spec update_custom_fields(binary) :: map()
  def update_custom_fields(issue_id) do
    body =
      Poison.encode!(%{
        "customFields" => [
          %{
            "name" => "Pull Requests",
            # "id" => "139-12",
            "$type" => "TextIssueCustomField",
            "value" => %{"text" => "123321444"}
          }
        ]
      })

    response =
      HTTPoison.post!(
        @base_path <> "issues/" <> issue_id,
        body,
        [{"Bearer", @token}, {"content-type", "application/json"}]
      )

    Poison.decode!(response.body)
  end
end
