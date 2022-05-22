defmodule EdcNewsCrawler.CategoriesList do
  use GenServer

  @impl true
  def init(_args) do
    {:ok, %{list: ["Ukraine", "Apple"]}}
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def handle_call(:next, _from, %{list: [current | rest]}) do
    {:reply, current, %{list: rest ++ [current]}}
  end
end
