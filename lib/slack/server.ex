defmodule Slackyt.Slack.Server do
  use GenServer

  @token Application.get_env(:slack, :api_token)

  # Service functions
  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    {:ok, _rtm} = Slack.Bot.start_link(Slackyt.Slack.Rtm, [], @token)

    {:ok, []}
  end
end
