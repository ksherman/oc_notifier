import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :oc_notifier, OcNotifier.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "oc_notifier_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :oc_notifier, OcNotifierWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "acjjuMJPziuC3FDr/H+05z9S+R37DAHQ6Ci+HFGwTc31S3IEmKioMO8nWS4VI585",
  server: false

# In test we don't send emails
config :oc_notifier, OcNotifier.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

config :oc_notifier, :basic_auth, username: "admin", password: "secret"

config :oc_notifier, Oban, testing: :inline
