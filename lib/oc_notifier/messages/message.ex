defmodule OcNotifier.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "message" do
    field :text, :string
    field :send_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:text, :send_at])
    |> validate_required([:text, :send_at])
  end
end
