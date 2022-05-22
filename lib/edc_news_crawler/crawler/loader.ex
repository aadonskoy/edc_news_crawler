defmodule EdcNewsCrawler.Crawler.Loader do
  require Logger

  def load_news do
    case HTTPoison.get(url()) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        %{"articles" => articles} = Jason.decode!(body)
        {:ok, articles}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Logger.error("Can't find")
        {:error, :not_found}
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("Can't load articles: #{reason}")
        {:error, reason}
    end
  end

  def url do
    # TODO check a way to properly define env variable
    loader_config = Application.get_env(:edc_news_crawler, EdcNewsCrawler.Crawler.Loader)
    "#{loader_config[:url]}/everything?q=Ukraine&sortBy=publishedAt&apiKey=#{loader_config[:token]}"
  end
end
