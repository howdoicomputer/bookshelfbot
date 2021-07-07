defmodule BookshelfBotDiscord.SlashCommands.Book do
  @moduledoc """
  Handles /book slash command
  """

  require Logger
  require Cachex

  alias BookshelfBot.GoogleBooks
  alias BookshelfBot.GoogleBooks.Structs.Book

  import Nostrum.Struct.Embed

  def get_command,
    do: %{
      name: "book",
      description: "Query for a book from Google Books",
      options: [
        %{
          type: 3,
          name: "title",
          description: "Book title",
          required: true
        }
      ]
    }

  @spec handle_interaction(any(), String.t) :: %{embeds: [Embed.t]}
  def handle_interaction(_interaction, book_title) do
    # Perform a query to the in-memory cache.
    #
    # Pattern match on there not being an entry first. If there is not an entry,
    # then query the Google Books API and create a Book struct and store it in the
    # cache. Then return a Discord embed.
    #
    # If the pattern match returns for there being an entry, then return a Discord
    # embed for that cache entry.
    #
    book_title = String.downcase(book_title)
    case Cachex.get(:bookshelfbot, book_title) do
      {:ok, nil} ->
        Logger.debug("#{book_title} not found in cache.")

        {:ok, resp} = GoogleBooks.query_book(book_title)

        volume_info = resp.body |> Map.get("items") |> List.first |> Map.get("volumeInfo")
        book = %Book{
          author: volume_info |> Map.get("authors") |> List.first,
          thumbnail: volume_info |> Map.get("imageLinks") |> Map.get("thumbnail"),
          title: volume_info |> Map.get("title"),
          pages: volume_info |> Map.get("pageCount"),
          rating: volume_info |> Map.get("averageRating") |> Kernel.inspect,
          published: volume_info |> Map.get("publishedDate"),
          description: volume_info |> Map.get("description")
        }

        Cachex.put(:bookshelfbot, book_title, book)

        %{embeds: [book_embed(book)]}
      {:ok, book} ->
        Logger.debug("Fetching #{book_title} from cache")

        %{embeds: [book_embed(book)]}
     end
  end

  @spec book_embed(Book.t) :: Embed.t
  defp book_embed(book) do
    %Nostrum.Struct.Embed{}
    |> put_title(book.title)
    |> put_field("Author", book.author)
    |> put_field("Pages", book.pages)
    |> put_field("Rating", book.rating)
    |> put_field("Published", book.published)
    |> put_description(book.description)
    |> put_image(book.thumbnail)
  end
end
