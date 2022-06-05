# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :edc_news_crawler,
  ecto_repos: [EdcNewsCrawler.Repo]

# Configures the endpoint
config :edc_news_crawler, EdcNewsCrawlerWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: EdcNewsCrawlerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: EdcNewsCrawler.PubSub,
  live_view: [signing_salt: "oJsH0kXm"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :edc_news_crawler, EdcNewsCrawler.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :edc_news_crawler, EdcNewsCrawler.Crawler.Scheduler,
  jobs: [
    {
      "*/15 * * * *",
      fn ->
        category = GenServer.call(EdcNewsCrawler.CategoriesList, :next_newsapi)
        EdcNewsCrawler.Crawler.Cache.store(:newsapi, category)
      end
    },
    {
      "*/8 * * * *",
      fn ->
        category = GenServer.call(EdcNewsCrawler.CategoriesList, :next_newsdata)
        EdcNewsCrawler.Crawler.Cache.store(:newsdata, category)
      end
    }
  ]

  news_api_token = System.get_env("NEWS_API_TOKEN") || ""
  news_api_url = System.get_env("NEWS_API_URL") || "https://newsapi.org/v2"

  newsdata_api_token = System.get_env("NEWSDATA_API_TOKEN") || ""
  newsdata_api_url = System.get_env("NEWSDATA_API_URL") || "https://newsdata.io/api/1/news"

  config :edc_news_crawler, EdcNewsCrawler.Crawler.Loader,
    token: news_api_token,
    url: news_api_url,
    newsdata_token: newsdata_api_token,
    newsdata_url: newsdata_api_url

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
