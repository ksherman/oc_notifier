defmodule OcNotifier.MessagesTest do
  use OcNotifier.DataCase

  alias OcNotifier.Messages

  describe "message" do
    alias OcNotifier.Messages.Message

    import OcNotifier.MessagesFixtures

    @invalid_attrs %{text: nil}

    test "list_message/0 returns all message" do
      message = message_fixture()
      assert Messages.list_message() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Messages.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      valid_attrs = %{text: "some text"}

      assert {:ok, %Message{} = message} = Messages.create_message(valid_attrs)
      assert message.text == "some text"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      update_attrs = %{text: "some updated text"}

      assert {:ok, %Message{} = message} = Messages.update_message(message, update_attrs)
      assert message.text == "some updated text"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Messages.update_message(message, @invalid_attrs)
      assert message == Messages.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Messages.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Messages.change_message(message)
    end
  end

  describe "message" do
    alias OcNotifier.Messages.Message

    import OcNotifier.MessagesFixtures

    @invalid_attrs %{text: nil, send_at: nil}

    test "list_message/0 returns all message" do
      message = message_fixture()
      assert Messages.list_message() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Messages.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      valid_attrs = %{text: "some text", send_at: ~U[2024-11-23 17:46:00Z]}

      assert {:ok, %Message{} = message} = Messages.create_message(valid_attrs)
      assert message.text == "some text"
      assert message.send_at == ~U[2024-11-23 17:46:00Z]
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      update_attrs = %{text: "some updated text", send_at: ~U[2024-11-24 17:46:00Z]}

      assert {:ok, %Message{} = message} = Messages.update_message(message, update_attrs)
      assert message.text == "some updated text"
      assert message.send_at == ~U[2024-11-24 17:46:00Z]
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Messages.update_message(message, @invalid_attrs)
      assert message == Messages.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Messages.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Messages.change_message(message)
    end
  end
end
