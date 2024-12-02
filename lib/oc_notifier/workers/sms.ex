defmodule OcNotifier.Workers.SMS do
  use Oban.Worker, queue: :sms, max_attempts: 3

  require Logger

  @impl Oban.Worker
  def perform(%{args: %{"recipient" => recipient, "message" => _message}}) do
    Logger.info("Sending SMS to #{recipient["phone"]}")

    :ok
  end
end
