defmodule OcNotifier.Repo do
  use Ecto.Repo,
    otp_app: :oc_notifier,
    adapter: Ecto.Adapters.Postgres
end
