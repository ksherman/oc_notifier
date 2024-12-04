defmodule OcNotifierWeb.MessageLive.New do
  use OcNotifierWeb, :live_view

  import SaladUI.Accordion

  alias OcNotifier.Messages.Message
  alias OcNotifier.Recipients

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "New Message")
     |> assign(:message, %Message{})
     |> assign_recipients()}
  end

  @impl true
  def handle_info({OcNotifierWeb.MessageLive.FormComponent, {:saved, message}}, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "Message created successfully")
     |> push_navigate(to: ~p"/admin/messages/#{message.id}")}
  end

  defp assign_recipients(socket) do
    socket
    |> assign(:sms_recipients, Recipients.list_active_recipients_with_sms())
    |> assign(:email_recipients, Recipients.list_active_recipients_with_email())
  end
end
