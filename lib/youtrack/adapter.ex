defmodule Slackyt.YouTrack.Adapter do
  @base_path Application.get_env(:slackyt, :secret)[:base_path]
  @token Application.get_env(:slackyt, :secret)[:youtrack_token]
  @threads_field Application.get_env(:slackyt, :youtrack)[:threads_field]
  @slack_url Application.get_env(:slackyt, :secret)[:slack_url]

  @doc """
  Добавить список тредов карточки задачи в ютреке
  """
  @spec update_threads(%{
          :channel => binary,
          :task => binary,
          :thread => binary,
          :description => binary
        }) :: any()
  def update_threads(message) do
    thread_url =
      (@slack_url <> message.channel <> "/p" <> message.thread)
      |> wrap_url(message.description)

    message.task
    |> get_custom_fields()
    # Выбрать только поле с тредами
    |> Enum.filter(fn field -> field["name"] == "Threads" end)
    |> List.first()
    # Добавить строку с новым тредом
    |> then(fn field -> field["value"]["text"] || " " <> "\n - " <> thread_url end)
    |> update_custom_fields(message.task)
  end

  @spec wrap_url(binary, binary) :: binary
  defp wrap_url(thread_url, description) do
    # Обернуть УРЛ описанием задачи для красивого форматирования в ютреке
    if description do
      "[#{description}](#{thread_url})"
    else
      thread_url
    end
  end

  @doc """
  Запросить список кастомных полей таски по названию или айди. Пример названия: SERVICES-1489
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

  @doc """
  Обновить значение поля "треды" в карточке
  value: новое значение поля
  issue_id: айди задачи
  """
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
