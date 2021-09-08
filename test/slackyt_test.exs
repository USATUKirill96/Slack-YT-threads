defmodule SlackytTest do
  use ExUnit.Case
  doctest Slackyt

  test "greets the world" do
    assert Slackyt.hello() == :world
  end
end
