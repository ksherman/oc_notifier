import Config

if System.get_env("PHX_SERVER") do
  config :oc_notifier, OcNotifierWeb.Endpoint, server: true
end

config :oc_notifier,
  twilio_phone_number:
    System.get_env("TWILIO_PHONE_NUMBER") ||
      raise("""
      environment variable TWILIO_PHONE_NUMBER is missing.
      """)

config :oc_notifier, send_messages: System.get_env("SEND_MESSAGES", "true") == "true"

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  config :oc_notifier, OcNotifier.Repo,
    # ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "elgin-winter-shelter.org"
  port = String.to_integer(System.get_env("PORT") || "8080")

  config :oc_notifier, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  config :oc_notifier, OcNotifierWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [ip: {0, 0, 0, 0, 0, 0, 0, 0}, port: port],
    secret_key_base: secret_key_base

  config :oc_notifier, :basic_auth,
    username: System.get_env("BASIC_AUTH_USERNAME"),
    password: System.get_env("BASIC_AUTH_PASSWORD")

  config :swoosh, :api_client, Swoosh.ApiClient.Req

  config :oc_notifier, OcNotifier.Mailer,
    adapter: Swoosh.Adapters.AmazonSES,
    region: "us-west-2",
    access_key: System.get_env("AWS_ACCESS_KEY"),
    secret: System.get_env("AWS_SECRET_KEY")

  config :ex_twilio,
    account_sid: System.get_env("TWILIO_ACCOUNT_SID"),
    auth_token: System.get_env("TWILIO_AUTH_TOKEN")
end
