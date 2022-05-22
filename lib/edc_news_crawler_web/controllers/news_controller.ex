defmodule EdcNewsCrawlerWeb.NewsController do
  use EdcNewsCrawlerWeb, :controller

  def index(conn, _params) do
    news = EdcNewsCrawler.Crawler.Cache.get_all
    render(conn, "news.json", news: news)
  end

  def show(conn, params) do
    news = EdcNewsCrawler.Crawler.Cache.get_category(params["id"])
    render(conn, "news.json", news: news)
  end
end
