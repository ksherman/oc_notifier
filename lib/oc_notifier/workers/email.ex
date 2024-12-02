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
    |> text_body(message["text"])
    |> Mailer.deliver()
  end
end
