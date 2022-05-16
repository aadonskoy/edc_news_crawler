defmodule EdcNewsCrawlerWeb.PageController do
  use EdcNewsCrawlerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
