defmodule OcNotifierWeb.RecipientLiveTest do
  use OcNotifierWeb.ConnCase

  import Phoenix.LiveViewTest
  import OcNotifier.RecipientsFixtures

  @create_attrs %{name: "some name", phone: 42, email: "some email", is_active: true}
  @update_attrs %{name: "some updated name", phone: 43, email: "some updated email", is_active: false}
  @invalid_attrs %{name: nil, phone: nil, email: nil, is_active: false}

  defp create_recipient(_) do
    recipient = recipient_fixture()
    %{recipient: recipient}
  end

  describe "Index" do
    setup [:create_recipient]

    test "lists all recipients", %{conn: conn, recipient: recipient} do
      {:ok, _index_live, html} = live(conn, ~p"/recipients")

      assert html =~ "Listing Recipients"
      assert html =~ recipient.name
    end

    test "saves new recipient", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/recipients")

      assert index_live |> element("a", "New Recipient") |> render_click() =~
               "New Recipient"

      assert_patch(index_live, ~p"/recipients/new")

      assert index_live
             |> form("#recipient-form", recipient: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#recipient-form", recipient: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/recipients")

      html = render(index_live)
      assert html =~ "Recipient created successfully"
      assert html =~ "some name"
    end

    test "updates recipient in listing", %{conn: conn, recipient: recipient} do
      {:ok, index_live, _html} = live(conn, ~p"/recipients")

      assert index_live |> element("#recipients-#{recipient.id} a", "Edit") |> render_click() =~
               "Edit Recipient"

      assert_patch(index_live, ~p"/recipients/#{recipient}/edit")

      assert index_live
             |> form("#recipient-form", recipient: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#recipient-form", recipient: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/recipients")

      html = render(index_live)
      assert html =~ "Recipient updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes recipient in listing", %{conn: conn, recipient: recipient} do
      {:ok, index_live, _html} = live(conn, ~p"/recipients")

      assert index_live |> element("#recipients-#{recipient.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#recipients-#{recipient.id}")
    end
  end

  describe "Show" do
    setup [:create_recipient]

    test "displays recipient", %{conn: conn, recipient: recipient} do
      {:ok, _show_live, html} = live(conn, ~p"/recipients/#{recipient}")

      assert html =~ "Show Recipient"
      assert html =~ recipient.name
    end

    test "updates recipient within modal", %{conn: conn, recipient: recipient} do
      {:ok, show_live, _html} = live(conn, ~p"/recipients/#{recipient}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Recipient"

      assert_patch(show_live, ~p"/recipients/#{recipient}/show/edit")

      assert show_live
             |> form("#recipient-form", recipient: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#recipient-form", recipient: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/recipients/#{recipient}")

      html = render(show_live)
      assert html =~ "Recipient updated successfully"
      assert html =~ "some updated name"
    end
  end
end
