defmodule OcNotifier.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false

  alias OcNotifier.Repo

  alias OcNotifier.Messages.Message
  alias OcNotifier.Recipients

  @doc """
  Returns the list of message.

  ## Examples

      iex> list_message()
      [%Message{}, ...]

  """
  def list_message do
    Repo.all(Message)
  end

  def get_latest_message do
    yesterday = DateTime.utc_now() |> DateTime.add(-24, :hour)

    Message
    |> where([m], m.sent_at > ^yesterday)
    |> order_by(desc: :inserted_at)
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  def enqueue_emails(message) do
    Recipients.list_active_recipients_with_email()
    |> Enum.map(&OcNotifier.Workers.Email.new(%{recipient: &1, message: message}))
    |> Oban.insert_all(queue: :email)
  end

  def enqueue_sms(message) do
    Recipients.list_active_recipients_with_sms()
    |> Enum.map(&OcNotifier.Workers.SMS.new(%{recipient: &1, message: message}))
    |> Oban.insert_all(queue: :sms)
  end
end
