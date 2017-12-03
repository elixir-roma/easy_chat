defmodule EasyChat.Router do
  use Plug.Router
  @moduledoc """
  The router is the core of every web application, it's role is to route
  requests for different paths and  HTTP verbs to different handlers.
  """

  if Mix.env == :dev do
    plug Plug.Debugger
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

  forward "/api/auth", to: EasyChat.Auth.Router

  match _, do: send_resp(conn, 200, render_layout())

  defp render_layout do
    unquote File.read!(__DIR__ <> "/../../priv/static/html/layout.html")
  end
end
