defmodule OcNotifierWeb.PageController do
  use OcNotifierWeb, :controller

  def home(conn, _params) do
    latest_message = OcNotifier.Messages.get_latest_message()

    render(conn, :home, layout: false, latest_message: latest_message)
  end
end
