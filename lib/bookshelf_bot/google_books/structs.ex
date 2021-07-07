defmodule BookshelfBot.GoogleBooks.Structs.Book do
  @moduledoc """
  A struct for tracking book metadata returned from the Google Books API
  """
  defstruct description: "",
    author: "",
    thumbnail: "",
    title: "",
    pages: 0,
    rating: "",
    published: ""

  @type t :: %__MODULE__{
    author: String.t(),
    thumbnail: String.t(),
    title: String.t(),
    pages: Integer.t(),
    rating: String.t(),
    published: String.t()
  }
end
