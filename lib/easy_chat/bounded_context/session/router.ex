defmodule EasyChat.BoundedContext.Session.Router do
  use Plug.Router
  @moduledoc false

  alias EasyChat.BoundedContext.Session.PostSession
  alias EasyChat.BoundedContext.Session.CgetSession
  alias EasyChat.BoundedContext.Session.GuardPipeline

  plug :match

  post "/", to: PostSession

  get "/"  do
    GuardPipeline.call(conn, route: fn conn ->
      CgetSession.call(conn, [])
    end)
  end

plug :dispatch
end
