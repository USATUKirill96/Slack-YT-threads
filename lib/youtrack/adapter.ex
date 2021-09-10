defmodule Slackyt.YouTrack.Adapter do
  @base_path Application.get_env(:slackyt, :secret)[:base_path]
  @token Application.get_env(:slackyt, :secret)[:youtrack_token]
  @threads_field Application.get_env(:slackyt, :youtrack)[:threads_field]

  def update_threads(message) do
    thread_url =
      "https://smenateam.slack.com/archives/" <> message.channel <> "/p" <> message.thread

    message.task
    |> get_custom_fields()
    |> Enum.filter(fn field -> field["name"] == "Threads" end)
    |> List.first()
    |> then(fn field -> field["value"]["text"] <> "\n - " <> thread_url end)
    |> update_custom_fields(message.task)
  end

  @doc """
  Запросить список полей таски по названию или айди. Пример названия: SERVICES-1489
  """
  @spec get_custom_fields(binary) :: map()
  def get_custom_fields(issue_id) do
    response =
      HTTPoison.get!(
        @base_path <> "issues/" <> issue_id <> "/customFields/?fields=name,value(text)",
        [{"Bearer", @token}, {"content-type", "application/json"}]
      )

    Poison.decode!(response.body)
  end

  @spec update_custom_fields(binary, binary) :: map()
  def update_custom_fields(value, issue_id) do
    body =
      Poison.encode!(%{
        "customFields" => [
          %{
            "name" => @threads_field,
            "$type" => "TextIssueCustomField",
            "value" => %{"text" => value}
          }
        ]
      })

    response =
      HTTPoison.post!(
        @base_path <> "issues/" <> issue_id <> "/?muteUpdateNotifications=true/",
        body,
        [{"Bearer", @token}, {"content-type", "application/json"}]
      )

    Poison.decode!(response.body)
  end
end
