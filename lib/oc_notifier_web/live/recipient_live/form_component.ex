defmodule OcNotifierWeb.RecipientLive.FormComponent do
  use OcNotifierWeb, :live_component

  alias OcNotifier.Recipients

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage recipient records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="recipient-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:phone]} type="number" label="Phone" />
        <.input field={@form[:email]} type="text" label="Email" />
        <.input field={@form[:is_active]} type="checkbox" label="Is active" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Recipient</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{recipient: recipient} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Recipients.change_recipient(recipient))
     end)}
  end

  @impl true
  def handle_event("validate", %{"recipient" => recipient_params}, socket) do
    changeset = Recipients.change_recipient(socket.assigns.recipient, recipient_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"recipient" => recipient_params}, socket) do
    save_recipient(socket, socket.assigns.action, recipient_params)
  end

  defp save_recipient(socket, :edit, recipient_params) do
    case Recipients.update_recipient(socket.assigns.recipient, recipient_params) do
      {:ok, recipient} ->
        notify_parent({:saved, recipient})

        {:noreply,
         socket
         |> put_flash(:info, "Recipient updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_recipient(socket, :new, recipient_params) do
    case Recipients.create_recipient(recipient_params) do
      {:ok, recipient} ->
        notify_parent({:saved, recipient})

        {:noreply,
         socket
         |> put_flash(:info, "Recipient created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
