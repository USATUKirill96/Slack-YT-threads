defmodule Slackyt.Slack.Rtm do
  use Slack
  alias Slackyt.Slack.Message

  def handle_connect(slack, state) do
    IO.puts("Connected as #{slack.me.name}")
    {:ok, state}
  end

  @doc """
  Хэндлер для событий получения сообщений из канала
  """
  def handle_event(message = %{type: "message"}, slack, state)
      when is_binary(message.thread_ts) do
    if Message.for_me?(message, slack) do
      Message.parse_message(message)
      |> Slackyt.YouTrack.Adapter.update_threads()
    end

    {:ok, state}
  end

  def handle_event(_, _, state), do: {:ok, state}

  @doc """
  Используется для отправки сообщений в слак
  """
  def handle_info({:message, text, channel}, slack, state) do
    send_message(text, channel, slack)
    {:ok, state}
  end

  def handle_info(_, _, state), do: {:ok, state}
end
