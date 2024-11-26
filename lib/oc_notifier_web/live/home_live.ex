defmodule OcNotifierWeb.HomeLive do
  use OcNotifierWeb, :live_view

  def mount(_params, _session, socket) do
    latest_message = OcNotifier.Messages.get_latest_message()

    {:ok,
     assign(
       socket,
       latest_message: latest_message,
       timezone: "America/Chicago",
       show_modal: false
     ), layout: false}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, assign(socket, show_modal: false)}
  end

  def handle_event("open_modal", _, socket) do
    {:noreply, assign(socket, show_modal: true)}
  end

  def handle_event("close_modal", _, socket) do
    {:noreply, assign(socket, show_modal: false)}
  end
end
