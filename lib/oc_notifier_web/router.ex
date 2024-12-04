defmodule OcNotifierWeb.Router do
  use OcNotifierWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {OcNotifierWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :basic_auth_required do
    plug :basic_auth
  end

  scope "/", OcNotifierWeb do
    pipe_through :browser

    live "/", HomeLive
  end

  scope "/admin", OcNotifierWeb do
    pipe_through [:browser, :basic_auth_required]

    scope "/messages" do
      live "/", MessageLive.Index, :index
      live "/new", MessageLive.New, :new
      live "/:id/edit", MessageLive.Index, :edit
      live "/:id", MessageLive.Show, :show
      live "/:id/show/edit", MessageLive.Show, :edit
    end

    scope "/recipients" do
      live "/", RecipientLive.Index, :index
      live "/new", RecipientLive.Index, :new
      live "/:id/edit", RecipientLive.Index, :edit
      live "/:id", RecipientLive.Show, :show
      live "/:id/show/edit", RecipientLive.Show, :edit
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", OcNotifierWeb do
  #   pipe_through :api
  # end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:oc_notifier, :dev_routes) do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  defp basic_auth(conn, _opts) do
    username = Application.get_env(:oc_notifier, :basic_auth)[:username]
    password = Application.get_env(:oc_notifier, :basic_auth)[:password]

    Plug.BasicAuth.basic_auth(conn, username: username, password: password)
  end
end
