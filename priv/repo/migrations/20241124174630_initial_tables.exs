defmodule OcNotifier.Repo.Migrations.InitialTables do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :text, :text
      add :send_at, :naive_datetime
      add :sent_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create table(:recipients, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :phone, :bigint
      add :email, :string
      add :is_active, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end

    # Messages table indexes
    create index(:messages, [:sent_at])
    create index(:messages, [:inserted_at])

    # Recipients table indexes
    create unique_index(:recipients, [:phone])
    create unique_index(:recipients, [:email])
    create index(:recipients, [:is_active])
  end
end
