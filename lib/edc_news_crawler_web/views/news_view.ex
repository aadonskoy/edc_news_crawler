defmodule EdcNewsCrawlerWeb.NewsView do
  use EdcNewsCrawlerWeb, :view

  def render("news.json", %{news: news}) do
    news
  end
end
