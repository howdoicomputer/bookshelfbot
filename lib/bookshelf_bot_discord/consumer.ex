defmodule BookshelfBotDiscord.Consumer do
  @moduledoc """
  A Nostrum GenServer implementation that dispatches function calls according to incoming event type.
  """
  use Nostrum.Consumer

  require Logger

  alias BookshelfBotDiscord.SlashCommands

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:READY, _data, _ws_state}) do
    SlashCommands.register_commands()

    version = to_string(Application.spec(:bookshelfbot, :vsn))
    Nostrum.Api.update_status(:online, "on v#{version}")

    Logger.info("Bot started!")
  end

  def handle_event({:INTERACTION_CREATE, interaction, _ws_state}) do
    SlashCommands.handle_interaction(interaction)
  end

  def handle_event(_event) do
    :noop
  end
end
