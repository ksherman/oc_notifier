defmodule OcNotifierWeb.MessageLive.Index do
  use OcNotifierWeb, :live_view

  alias OcNotifier.Messages
  alias OcNotifier.Messages.Message

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :message_collection, Messages.list_message())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Message")
    |> assign(:message, Messages.get_message!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Message")
    |> assign(:message, %Message{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Message")
    |> assign(:message, nil)
  end

  @impl true
  def handle_info({OcNotifierWeb.MessageLive.FormComponent, {:saved, message}}, socket) do
    {:noreply, stream_insert(socket, :message_collection, message)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    message = Messages.get_message!(id)
    {:ok, _} = Messages.delete_message(message)

    {:noreply, stream_delete(socket, :message_collection, message)}
  end
end
