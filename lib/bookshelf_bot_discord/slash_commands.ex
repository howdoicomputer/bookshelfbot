defmodule BookshelfBotDiscord.SlashCommands do
  @moduledoc """
  Register slash commands and handles interactions
  """

  require Logger
  alias Nostrum.Api

  alias BookshelfBotDiscord.SlashCommands.{Book, Info}

  @spec register_commands() :: :ok
  def register_commands do
    commands = [
      Book.get_command(),
      Info.get_command()
    ]

    commands
    |> Enum.each(fn command ->
      if Application.fetch_env!(:bookshelfbot, :env) === :prod do
        case Api.create_global_application_command(command) do
          {:ok, command} -> Logger.info("Created #{command.title} global command")
          error -> Logger.error(error)
        end
      else
        case Application.fetch_env(:bookshelfbot, :test_guild_id) do
          {:ok, guild_id} ->
            case Api.create_guild_application_command(guild_id, command) do
              {:ok, command} -> Logger.info("Created #{command.title} guild command")
              error -> Logger.error(error)
            end
          _ -> :noop
        end
      end
    end)
  end

  def handle_interaction(interaction) do
    Logger.metadata(
      interaction_data: interaction.data,
      guild_id: interaction.guild_id,
      channel_id: interaction.channel_id,
      user_id: interaction.member && interaction.member.user.id
    )

    Logger.debug("Interaction received")

    try do
      Api.create_interaction_response(interaction, %{
        type: 4,
        data: interaction_response(interaction)
      })
    rescue
      err ->
        Logger.error(err)

        Api.create_interaction_response(interaction, %{
          type: 4,
          data: %{content: "Something went wrong :("}
        })
    end
  end

  defp interaction_response(interaction) do
    # A way of interacting with every interaction that comes into the consumer. It works by
    # matching against each parsed interaction to determine which command was called and then
    # dispatching to the modules that handle that interaction.
    #
    case parse_interaction(interaction.data) do
      {:command, ["book", book_title]} ->
        Book.handle_interaction(interaction, book_title)
      {:command, ["info"]} ->
        Info.handle_interaction(interaction)
      _ ->
        %{content: "Unknown command"}
    end
  end

  defp parse_interaction(interaction_data) do
    # When an interaction event is received from Discord, it has a structure of
    # Nostrum.Struct.Interaction (https://hexdocs.pm/nostrum/Nostrum.Struct.Interaction.html).
    #
    # This function takes Interaction.data() and coerces out the command of the interaction
    # and the arguments it received and puts them into a map to be pattern matched against.
    #
    case Map.get(interaction_data, :custom_id) do
      nil ->
        args =
          interaction_data
          |> Map.get(:options, [])
          |> Enum.map(fn opt -> opt.value end)

        {:command, [interaction_data.name] ++ args}

      custom_id ->
        {:component, String.split(custom_id, ":")}
    end
  end
end
