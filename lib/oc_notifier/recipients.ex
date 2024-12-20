defmodule OcNotifier.Recipients do
  @moduledoc """
  The Recipients context.
  """

  import Ecto.Query, warn: false
  alias OcNotifier.Repo

  alias OcNotifier.Recipients.Recipient

  @doc """
  Returns the list of recipients.

  ## Examples

      iex> list_recipients()
      [%Recipient{}, ...]

  """
  def list_recipients do
    Repo.all(Recipient)
  end

  def list_active_recipients_with_email do
    Repo.all(from r in Recipient, where: not is_nil(r.email), where: r.is_active == true)
  end

  def list_active_recipients_with_sms do
    Repo.all(from r in Recipient, where: not is_nil(r.phone), where: r.is_active == true)
  end

  @doc """
  Gets a single recipient.

  Raises `Ecto.NoResultsError` if the Recipient does not exist.

  ## Examples

      iex> get_recipient!(123)
      %Recipient{}

      iex> get_recipient!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recipient!(id), do: Repo.get!(Recipient, id)

  @doc """
  Creates a recipient.

  ## Examples

      iex> create_recipient(%{field: value})
      {:ok, %Recipient{}}

      iex> create_recipient(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipient(attrs \\ %{}) do
    %Recipient{}
    |> Recipient.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a recipient.

  ## Examples

      iex> update_recipient(recipient, %{field: new_value})
      {:ok, %Recipient{}}

      iex> update_recipient(recipient, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipient(%Recipient{} = recipient, attrs) do
    recipient
    |> Recipient.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a recipient.

  ## Examples

      iex> delete_recipient(recipient)
      {:ok, %Recipient{}}

      iex> delete_recipient(recipient)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recipient(%Recipient{} = recipient) do
    Repo.delete(recipient)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipient changes.

  ## Examples

      iex> change_recipient(recipient)
      %Ecto.Changeset{data: %Recipient{}}

  """
  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  @doc """
  Gets a recipient by ID.
  Returns nil if the recipient doesn't exist.
  """
  def get_recipient(id) do
    Repo.get(Recipient, id)
  end
end
