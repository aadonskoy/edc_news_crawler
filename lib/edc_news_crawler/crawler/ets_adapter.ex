defmodule EdcNewsCrawler.Crawler.EtsAdapter do
  def store_batch(table, data, category) do
    # TODO add index and reset on each store
    data
    |> Enum.each(fn item ->:ets.insert(table, {item["url"], category, Jason.encode!(item)}) end)

    :ok
  end

  def get_all(table) do
    :ets.tab2list(table)
    |> decode_and_order
  end

  def get_category(table, category) do
    :ets.match_object(table, {:_, category, :_})
    |> decode_and_order
  end

  defp decode_and_order(data) do
    data
    |> Enum.map(fn {_key, _category, value} -> Jason.decode!(value) end)
    |> Enum.sort_by(fn item -> item["publishedAt"] end)
  end
end
