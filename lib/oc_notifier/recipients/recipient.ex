defmodule OcNotifier.Recipients.Recipient do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:name, :phone, :email, :id]}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "recipients" do
    field :name, :string
    field :phone, :integer
    field :email, :string
    field :is_active, :boolean, default: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(recipient, attrs) do
    recipient
    |> cast(attrs, [:name, :phone, :email, :is_active])
    |> validate_required([:name, :is_active])
    |> unique_constraint(:phone, message: "Phone number already exists")
    |> unique_constraint(:email, message: "Email already exists")
  end
end
