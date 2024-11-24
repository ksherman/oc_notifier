defmodule OcNotifier.Repo.Migrations.CreateRecipients do
  use Ecto.Migration

  def change do
    create table(:recipients, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :phone, :integer
      add :email, :string
      add :is_active, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
