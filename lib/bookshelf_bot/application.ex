defmodule BookshelfBot.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BookshelfBotDiscord.Consumer,
      {Cachex, name: :bookshelfbot}
    ]

    opts = [strategy: :one_for_one, name: BookshelfBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
