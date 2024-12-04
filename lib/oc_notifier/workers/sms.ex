defmodule OcNotifier.Workers.SMS do
  use Oban.Worker, queue: :sms, max_attempts: 3

  require Logger

  alias OcNotifier.Integrations.SmsMessaging

  @impl Oban.Worker
  def perform(%{args: %{"recipient" => recipient, "message" => message}}) do
    Logger.info("Sending SMS to #{recipient["phone"]}")

    SmsMessaging.send_message(recipient["phone"], message["text"])
  end
end
