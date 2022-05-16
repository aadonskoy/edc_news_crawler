defmodule EdcNewsCrawler.Crawler.Cache do
  use Agent
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
    %{
      "author" => "Farnaz Fassihi",
      "content" => "In the days after the Russian withdrawal from the outskirts of Kyiv, a driver named Oleg Naumenko opened the trunk of an abandoned car and it exploded, killing him instantly.The car had been booby-tr… [+5268 chars]",
      "description" => "President Volodymyr Zelensky praised the U.S. for sending more military equipment as Ukraine anticipated a new stage of the war. Ukraine said its forces “seriously damaged” a Russian warship.",
      "publishedAt" => "2022-04-14T05:04:55Z",
      "source" => %{"id" => nil, "name" => "New York Times"},
      "title" => "The U.N. warns the Ukraine war has disrupted the flow of food, fuel and money around the world.",
      "url" => "https://www.nytimes.com/live/2022/04/14/world/ukraine-russia-war-news",
      "urlToImage" => "https://static01.nyt.com/images/2022/04/13/world/13ukraine-blog-UN-guterres/13ukraine-blog-UN-guterres-facebookJumbo.jpg"
    },
    .....
  """

  def start_link(_opts) do
    Agent.start_link(fn ->
      :ets.new(:news_table, [:named_table, :protected])
    end)
  end

  def get_all(cache) do
    Agent.get(cache, &EtsAdapter.get_all(&1))
  end

  def store(cache) do
    Agent.update(cache, fn table ->
      case Loader.load_news() do
        {:ok, articles} ->
          EtsAdapter.store_batch(table, articles)
        {:error, _} ->
          table
      end
    end)
  end
end
