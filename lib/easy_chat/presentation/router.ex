defmodule EasyChat.Presentation.Router do
  use Plug.Router
  @moduledoc """
  This is the main router, its task is to define the general
  pipeline and redirect requests to more specific routers;
  it also deals with the management of static files and the
  presentation of the single page application layout.
  """

  if Mix.env == :dev do
    plug Plug.Logger
  end

  plug :match
  plug Plug.Parsers, parsers: [:urlencoded, :json],
                     pass:  ["application/json"],
                     json_decoder: Poison

  plug Plug.Static,
    at: "/", from: {:easy_chat, "priv/static"}, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  plug :dispatch

  forward "/api/session", to: EasyChat.BoundedContext.Session.Router
  forward "/api/user", to: EasyChat.BoundedContext.User.Router

  match _, do: send_resp(conn, 200, render_layout())

  defp render_layout do
    unquote File.read!(__DIR__ <> "/../../../priv/static/html/layout.html")
  end
end
