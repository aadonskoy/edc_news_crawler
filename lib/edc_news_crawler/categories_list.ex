defmodule EdcNewsCrawler.CategoriesList do
  use GenServer

  @impl true
  def init(args) do
    {:ok, %{list: args}}
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: EdcNewsCrawler.CategoriesList)
  end

  @impl true
  def handle_call(:next, _from, %{list: [current | rest]}) do
    {:reply, current, %{list: rest ++ [current]}}
  end
end
