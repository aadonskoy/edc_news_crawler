defmodule EdcNewsCrawlerWeb.NewsController do
  use EdcNewsCrawlerWeb, :controller

  def index(conn, _params) do
    news = EdcNewsCrawler.Crawler.Cache.get_all
    render(conn, "news.json", news: news)
  end
end
