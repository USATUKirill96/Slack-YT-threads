defmodule Slackyt.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @token Application.get_env(:slack, :api_token)

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Slackyt.Worker.start_link(arg)
      # {Slackyt.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Slackyt.Supervisor]
    Slack.Bot.start_link(Slackyt.Slack.Rtm, [], @token)
    Supervisor.start_link(children, opts)
  end
end
