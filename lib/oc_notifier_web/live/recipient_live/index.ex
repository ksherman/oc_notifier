defmodule OcNotifierWeb.RecipientLive.Index do
  use OcNotifierWeb, :live_view

  alias OcNotifier.Recipients
  alias OcNotifier.Recipients.Recipient

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :recipients, Recipients.list_recipients())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Recipient")
    |> assign(:recipient, Recipients.get_recipient!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Recipient")
    |> assign(:recipient, %Recipient{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Recipients")
    |> assign(:recipient, nil)
  end

  @impl true
  def handle_info({OcNotifierWeb.RecipientLive.FormComponent, {:saved, recipient}}, socket) do
    {:noreply, stream_insert(socket, :recipients, recipient)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    recipient = Recipients.get_recipient!(id)
    {:ok, _} = Recipients.delete_recipient(recipient)

    {:noreply, stream_delete(socket, :recipients, recipient)}
  end
end
