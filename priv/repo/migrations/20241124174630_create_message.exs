defmodule OcNotifier.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:message, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :text, :text
      add :send_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
