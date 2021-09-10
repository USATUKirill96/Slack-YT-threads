defmodule Slackyt.Slack.Message do
  alias __MODULE__

  defstruct text: "", channel: "", thread_ts: ""

  @doc """
  Проверить, для бота ли предназначено сообщение
  """
  @spec for_me?(Message, Slack.State) :: boolean
  def for_me?(message, slack) do
    called =
      message.text
      |> String.split()
      |> List.first(nil)
      |> String.replace(["<", ">", "@"], "")

    slack.me.id == called
  end

  @doc """
  Распарсить сообщение от слака, выбрать нужные поля
  """
  @spec parse_message(Message) :: %{
          :task => binary | nil,
          :description => binary | nil,
          :channel => binary,
          :thread => binary
        }
  def parse_message(message) do
    # Отсекаем упоминание бота
    splitted_message = String.split(message.text) |> List.delete_at(0)

    %{}
    |> Map.put(:task, splitted_message |> Enum.at(0))
    |> Map.put(:description, splitted_message |> List.delete_at(0) |> Enum.join(" "))
    |> Map.put(:channel, message.channel)
    |> Map.put(:thread, message.thread_ts |> String.replace(".", ""))
  end
end
