defmodule BookshelfBot.GoogleBooks do
  @moduledoc """
  A very simple wrapper around the Google Books API.
  """
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://www.googleapis.com/books/v1"
  plug Tesla.Middleware.JSON

  @spec query_book(String.t) :: Tesla.Env.result
  @doc """
  Queries a book based on title.
  """
  def query_book(title) do
    get("/volumes", query: [q: String.replace(title, " ", "+")])
  end
end
