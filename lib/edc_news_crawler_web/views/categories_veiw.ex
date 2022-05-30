defmodule EdcNewsCrawlerWeb.CategoryView do
  use EdcNewsCrawlerWeb, :view

  def render("categories.json", %{categories: categories_list}) do
    %{categories: categories_list}
  end
end
