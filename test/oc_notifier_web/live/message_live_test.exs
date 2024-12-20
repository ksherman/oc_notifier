defmodule OcNotifierWeb.MessageLiveTest do
  use OcNotifierWeb.ConnCase

  import Phoenix.LiveViewTest
  import OcNotifier.MessagesFixtures

  @create_attrs %{text: "some text", send_at: "2024-11-23T17:46:00Z"}
  @update_attrs %{text: "some updated text", send_at: "2024-11-24T17:46:00Z"}
  @invalid_attrs %{text: nil, send_at: nil}

  defp create_message(_) do
    message = message_fixture()
    %{message: message}
  end

  describe "Index" do
    setup [:create_message]

    test "lists all message", %{conn: conn, message: message} do
      {:ok, _index_live, html} = live(conn, ~p"/admin/messages")

      assert html =~ "Listing Message"
      assert html =~ message.text
    end

    test "saves new message", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/messages")

      assert index_live |> element("a", "New Message") |> render_click() =~
               "New Message"

      assert_patch(index_live, ~p"/admin/messages/new")

      assert index_live
             |> form("#message-form", message: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#message-form", message: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/messages")

      html = render(index_live)
      assert html =~ "Message created successfully"
      assert html =~ "some text"
    end

    test "updates message in listing", %{conn: conn, message: message} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/messages")

      assert index_live |> element("#message-#{message.id} a", "Edit") |> render_click() =~
               "Edit Message"

      assert_patch(index_live, ~p"/admin/messages/#{message}/edit")

      assert index_live
             |> form("#message-form", message: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#message-form", message: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/messages")

      html = render(index_live)
      assert html =~ "Message updated successfully"
      assert html =~ "some updated text"
    end

    test "deletes message in listing", %{conn: conn, message: message} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/messages")

      assert index_live |> element("#message-#{message.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#message-#{message.id}")
    end
  end

  describe "Show" do
    setup [:create_message]

    test "displays message", %{conn: conn, message: message} do
      {:ok, _show_live, html} = live(conn, ~p"/admin/messages/#{message}")

      assert html =~ "Show Message"
      assert html =~ message.text
    end

    test "updates message within modal", %{conn: conn, message: message} do
      {:ok, show_live, _html} = live(conn, ~p"/admin/messages/#{message}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Message"

      assert_patch(show_live, ~p"/admin/messages/#{message}/show/edit")

      assert show_live
             |> form("#message-form", message: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#message-form", message: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/admin/messages/#{message}")

      html = render(show_live)
      assert html =~ "Message updated successfully"
      assert html =~ "some updated text"
    end
  end
end
