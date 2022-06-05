defmodule EdcNewsCrawler.Crawler.Loader do
  require Logger

  def load_news(provider, category) do
    case HTTPoison.get(url(provider, category)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        articles(Jason.decode!(body))
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Logger.error("Can't find")
        {:error, :not_found}
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("Can't load articles: #{reason}")
        {:error, reason}
    end
  end

  def url(:newsapi, category) do
    # TODO check a way to properly define env variable
    loader_config = Application.get_env(:edc_news_crawler, EdcNewsCrawler.Crawler.Loader)
    "#{loader_config[:url]}/everything?q=#{category}&sortBy=publishedAt&apiKey=#{loader_config[:token]}"
  end

  def url(:newsdata, category) do
    loader_config = Application.get_env(:edc_news_crawler, EdcNewsCrawler.Crawler.Loader)
    "#{loader_config[:newsdata_url]}?apikey=#{loader_config[:newsdata_token]}&category=#{category}"
    # "https://newsdata.io/api/1/news?apikey=YOUR_API_KEY"
  end

  defp articles(%{"articles" => items}), do: {:ok, items}
  defp articles(%{"results" => items}), do: {:ok, items}
end
