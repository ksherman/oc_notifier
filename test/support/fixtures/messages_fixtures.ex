defmodule OcNotifier.MessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `OcNotifier.Messages` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        text: "some text"
      })
      |> OcNotifier.Messages.create_message()

    message
  end

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        send_at: ~U[2024-11-23 17:46:00Z],
        text: "some text"
      })
      |> OcNotifier.Messages.create_message()

    message
  end
end
