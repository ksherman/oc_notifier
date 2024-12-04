defmodule OcNotifierWeb.MessageLive.FormComponent do
  use OcNotifierWeb, :live_component

  alias OcNotifier.Messages

  import SaladUI.Textarea

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-6">
      <%= if @title != "" do %>
        <.header>
          <%= @title %>
          <:subtitle>Use this form to send messages to subscribers.</:subtitle>
        </.header>
      <% end %>

      <.form
        :let={f}
        for={@form}
        phx-submit="save"
        class="grid items-start w-full gap-6"
        phx-target={@myself}
        phx-change="validate"
      >
        <.textarea
          name={f[:text].name}
          value={f[:text].value}
          class={error_class(f[:text])}
          placeholder="Your message"
        />

        <.input field={@form[:send_at]} type="datetime-local" label="Send at" />

        <.button phx-disable-with="Saving and scheduling...">Send Message</.button>
      </.form>
    </div>
    """
  end

  @impl true
  def update(%{message: message} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Messages.change_message(message))
     end)}
  end

  @impl true
  def handle_event("validate", %{"message" => message_params}, socket) do
    changeset = Messages.change_message(socket.assigns.message, message_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"message" => message_params}, socket) do
    save_message(socket, socket.assigns.action, message_params)
  end

  defp save_message(socket, :edit, message_params) do
    case Messages.update_message(socket.assigns.message, message_params) do
      {:ok, message} ->
        notify_parent({:saved, message})

        {:noreply,
         socket
         |> put_flash(:info, "Message updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_message(socket, :new, message_params) do
    case Messages.create_message(message_params) do
      {:ok, message} ->
        notify_parent({:saved, message})

        {:noreply,
         socket
         |> put_flash(:info, "Message created successfully")
         |> push_navigate(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp error_class(field) do
    if Enum.empty?(field.errors), do: "", else: "border-destructive text-destructive"
  end
end
