defmodule OcNotifier.Workers.Email do
  use Oban.Worker, queue: :email, max_attempts: 3

  require Logger

  import Swoosh.Email

  alias OcNotifier.Mailer

  @impl Oban.Worker
  def perform(%{args: %{"recipient" => recipient, "message" => message}}) do
    Logger.info("Sending Email to #{recipient["email"]}")

    new()
    |> from("no-reply@mail.elgin-winter-shelter.org")
    |> to(recipient["email"])
    |> subject("Elgin Winter Shelter Update")
    |> text_body(append_unsubscribe(recipient["id"], message["text"]))
    |> Mailer.deliver()
  end

  defp append_unsubscribe(recipient_id, text) do
    text <>
      """
      \n\n\n
      To unsubscribe from these emails, please visit https://elgin-winter-shelter.org/unsubscribe/email/#{recipient_id}.
      """
  end
end
