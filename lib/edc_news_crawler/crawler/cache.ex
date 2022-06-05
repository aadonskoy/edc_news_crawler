defmodule EdcNewsCrawler.Crawler.Cache do
  alias EdcNewsCrawler.Crawler.Loader
  alias EdcNewsCrawler.Crawler.EtsAdapter

  @doc """
  Format data
  url can be the unique key
  %{
  "articles" => [
    %{
      "author" => "Karissa Bell",
      "content" => "Meta has withdrawn\r\n a request it made to its oversight Board seeking guidance on shaping its content moderation policies amid Russias invasion of Ukraine. The company had originally asked the Oversi… [+1944 chars]",
      "description" => "Meta has withdrawn\r\n a request it made to its oversight Board seeking guidance on shaping its content moderation policies amid Russia’s invasion of Ukraine. The company had originally asked the Oversight Board for a policy advisory opinion (PAO) in March, fol…",
      "publishedAt" => "2022-05-11T19:36:38Z",
      "source" => %{"id" => "engadget", "name" => "Engadget"},
      "title" => "Meta withdraws Oversight Board request for help with Ukraine policies",
      "url" => "https://www.engadget.com/meta-withdraws-oversight-board-request-for-help-with-ukraine-policies-193638529.html",
      "urlToImage" => "https://s.yimg.com/os/creatr-uploaded-images/2021-01/4e4406f0-616e-11eb-bedf-b2adf9310de2"
    },
    .....
  """

  def get_all do
    EtsAdapter.get_all(:news_table)
  end

  def get_category(category) do
    EtsAdapter.get_category(:news_table, category)
  end

  def store(provider, category) do
    case Loader.load_news(provider, category) do
      {:ok, articles} ->
        :ok = EtsAdapter.store_batch(:news_table, articles, category)
        :ok
      {:error, error} ->
        {:error, error}
    end
  end
end
