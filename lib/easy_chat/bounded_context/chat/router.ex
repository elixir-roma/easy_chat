defmodule EasyChat.BoundedContext.Chat.Router do
  use Plug.Router
  @moduledoc false

  alias EasyChat.BoundedContext.Chat.CgetMessage
  alias EasyChat.BoundedContext.Session.GuardPipeline

  plug :match

  get "/"  do
    GuardPipeline.call(conn, route: fn conn ->
      CgetMessage.call(conn, [])
    end)
  end

  plug :dispatch
end
