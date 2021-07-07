import Config

config :logger,
  level: :debug,
  backends: [Ink]

config :logger, Ink, name: "bookshelfbot"
