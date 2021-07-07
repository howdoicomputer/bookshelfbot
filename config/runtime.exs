import Config

if config_env() == :prod do
  config :nostrum,
    token: System.get_env("DISCORD_TOKEN"),
    num_shards: :auto
end
