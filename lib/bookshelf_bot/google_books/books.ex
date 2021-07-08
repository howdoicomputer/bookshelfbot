defmodule BookshelfBot.GoogleBooks do
  @moduledoc """
  A very simple wrapper around the Google Books API.
  """
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://www.googleapis.com/books/v1"
  plug Tesla.Middleware.JSON

  @doc """
  Queries a book based on title.
  """
  @spec query_book(String.t) :: Tesla.Env.result
  def query_book(title) do
    get("/volumes", query: [q: String.replace(title, " ", "+")])
  end
end
