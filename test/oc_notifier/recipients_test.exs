defmodule OcNotifier.RecipientsTest do
  use OcNotifier.DataCase

  alias OcNotifier.Recipients

  describe "recipients" do
    alias OcNotifier.Recipients.Recipient

    import OcNotifier.RecipientsFixtures

    @invalid_attrs %{name: nil, phone: nil, email: nil, is_active: nil}

    test "list_recipients/0 returns all recipients" do
      recipient = recipient_fixture()
      assert Recipients.list_recipients() == [recipient]
    end

    test "get_recipient!/1 returns the recipient with given id" do
      recipient = recipient_fixture()
      assert Recipients.get_recipient!(recipient.id) == recipient
    end

    test "create_recipient/1 with valid data creates a recipient" do
      valid_attrs = %{name: "some name", phone: 42, email: "some email", is_active: true}

      assert {:ok, %Recipient{} = recipient} = Recipients.create_recipient(valid_attrs)
      assert recipient.name == "some name"
      assert recipient.phone == 42
      assert recipient.email == "some email"
      assert recipient.is_active == true
    end

    test "create_recipient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipients.create_recipient(@invalid_attrs)
    end

    test "update_recipient/2 with valid data updates the recipient" do
      recipient = recipient_fixture()

      update_attrs = %{
        name: "some updated name",
        phone: 43,
        email: "some updated email",
        is_active: false
      }

      assert {:ok, %Recipient{} = recipient} =
               Recipients.update_recipient(recipient, update_attrs)

      assert recipient.name == "some updated name"
      assert recipient.phone == 43
      assert recipient.email == "some updated email"
      assert recipient.is_active == false
    end

    test "update_recipient/2 with invalid data returns error changeset" do
      recipient = recipient_fixture()
      assert {:error, %Ecto.Changeset{}} = Recipients.update_recipient(recipient, @invalid_attrs)
      assert recipient == Recipients.get_recipient!(recipient.id)
    end

    test "delete_recipient/1 deletes the recipient" do
      recipient = recipient_fixture()
      assert {:ok, %Recipient{}} = Recipients.delete_recipient(recipient)
      assert_raise Ecto.NoResultsError, fn -> Recipients.get_recipient!(recipient.id) end
    end

    test "change_recipient/1 returns a recipient changeset" do
      recipient = recipient_fixture()
      assert %Ecto.Changeset{} = Recipients.change_recipient(recipient)
    end
  end
end
