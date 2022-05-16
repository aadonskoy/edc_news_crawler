defmodule EdcNewsCrawler.Repo do
  use Ecto.Repo,
    otp_app: :edc_news_crawler,
    adapter: Ecto.Adapters.Postgres
end
