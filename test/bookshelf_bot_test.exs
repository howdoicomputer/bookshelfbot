defmodule BookshelfBotTest do
  use ExUnit.Case
  doctest BookshelfBot

  test "greets the world" do
    assert BookshelfBot.hello() == :world
  end
end
