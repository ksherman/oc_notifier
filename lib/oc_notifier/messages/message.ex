defmodule OcNotifier.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "messages" do
    field :text, :string
    field :send_at, :naive_datetime
    field :sent_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:text, :send_at, :sent_at])
    |> validate_required([:text])
    |> set_default_send_at()
  end

  defp set_default_send_at(changeset) do
    changeset
    |> put_change(:send_at, NaiveDateTime.local_now() |> NaiveDateTime.add(3, :minute))
  end
end
