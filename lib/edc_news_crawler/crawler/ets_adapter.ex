defmodule EdcNewsCrawler.Crawler.EtsAdapter do
  def store_batch(table, data) do
    Enum.each(data, fn item ->
      :ets.insert_new(table, {item["url"], Jason.encode!(item)})
    end)

    table
  end

  def get_all(table) do
    :ets.tab2list(table)
    |> Enum.map(fn {_key, value} -> Jason.decode!(value) end)
  end
end
