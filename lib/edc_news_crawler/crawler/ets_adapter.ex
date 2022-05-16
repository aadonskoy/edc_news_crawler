defmodule EdcNewsCrawler.Crawler.EtsAdapter do
  def store_batch(table, data) do
    # TODO add index and reset on each store
    data
    |> Enum.each(fn item ->:ets.insert(table, {item["url"], Jason.encode!(item)}) end)

    :ok
  end

  def get_all(table) do
    :ets.tab2list(table)
    |> Enum.map(fn {_key, value} -> Jason.decode!(value) end)
    |> Enum.sort_by(fn item -> item["publishedAt"] end)
  end
end
