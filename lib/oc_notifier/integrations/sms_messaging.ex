defmodule OcNotifier.Integrations.SmsMessaging do
  alias ExTwilio.Message

  def send_message(to_phone_number, message_body) do
    Message.create(
      to: to_phone_number,
      from: twilio_phone_number(),
      body: message_body
    )
  end

  defp twilio_phone_number, do: Application.fetch_env!(:oc_notifier, :twilio_phone_number)
end
