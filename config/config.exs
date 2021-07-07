import Config

config :nostrum,
  token: System.get_env("DISCORD_TOKEN"),
  num_shards: :auto

config :bookshelfbot,
  env: Mix.env()

config :logger, :console,
  format: "\n$time [$level] $levelpad $message $metadata\n",
  metadata: [:interaction_data, :guild_id, :channel_id, :user_id]

config :tesla, adapter: Tesla.Adapter.Hackney

config :porcelain, driver: Porcelain.Driver.Basic

import_config "#{Mix.env()}.exs"
