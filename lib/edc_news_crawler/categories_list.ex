defmodule EdcNewsCrawler.CategoriesList do
  use GenServer

  @impl true
  def init(args) do
    {:ok, %{newsapi: args, newsdata: args}}
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: EdcNewsCrawler.CategoriesList)
  end

  @impl true
  def handle_call(:next_newsapi, _from, %{newsapi: [current | rest]} = state) do
    {:reply, current, %{state | newsapi: rest ++ [current]}}
  end

  @impl true
  def handle_call(:next_newsdata, _from, %{newsdata: [current | rest]} = state) do
    {:reply, current, %{state | newsdata: rest ++ [current]}}
  end
end
