defmodule EdcNewsCrawlerWeb.CategoryController do
  use EdcNewsCrawlerWeb, :controller

  def index(conn, _params) do
    categories = GenServer.call(EdcNewsCrawler.CategoriesList, :list)
    render(conn, "categories.json", categories: categories)
  end
end
