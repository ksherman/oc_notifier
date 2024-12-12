defmodule OcNotifierWeb.UnsubscribeLive do
  use OcNotifierWeb, :live_view
  alias OcNotifier.Recipients

  def mount(%{"recipient_id" => recipient_id}, _session, socket) do
    case Recipients.get_recipient(recipient_id) do
      nil ->
        {:ok,
         socket
         |> put_flash(:error, "Invalid unsubscribe link")
         |> redirect(to: ~p"/")}

      recipient ->
        case Recipients.update_recipient(recipient, %{email: nil}) do
          {:ok, _recipient} ->
            {:ok,
             socket
             |> assign(:page_title, "Unsubscribed")
             |> assign(:unsubscribed, true)}

          {:error, _changeset} ->
            {:ok,
             socket
             |> put_flash(:error, "Unable to unsubscribe. Please try again later.")
             |> redirect(to: ~p"/")}
        end
    end
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-2xl px-4 py-8 mx-auto">
      <div class="p-6 text-center bg-white rounded-lg shadow">
        <h1 class="mb-4 text-2xl font-bold">Email Unsubscribed</h1>
        <p class="mb-4 text-gray-600">
          You have been successfully unsubscribed from our email notifications.
        </p>
        <p class="text-sm text-gray-500">
          If you change your mind, please contact the administrator to resubscribe.
        </p>
      </div>
    </div>
    """
  end
end
