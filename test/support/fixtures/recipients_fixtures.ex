defmodule OcNotifier.RecipientsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OcNotifier.Recipients` context.
  """

  @doc """
  Generate a recipient.
  """
  def recipient_fixture(attrs \\ %{}) do
    {:ok, recipient} =
      attrs
      |> Enum.into(%{
        email: "some email",
        is_active: true,
        name: "some name",
        phone: 42
      })
      |> OcNotifier.Recipients.create_recipient()

    recipient
  end
end
