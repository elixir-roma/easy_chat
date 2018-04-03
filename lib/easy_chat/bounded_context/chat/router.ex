defmodule EasyChat.BoundedContext.Chat.Router do
  use Plug.Router
  @moduledoc false

  alias EasyChat.BoundedContext.Chat.CgetMessage

  plug :match

  get "/"  do
    GuardPipeline.call(conn, route: fn conn ->
      CgetSession.call(conn, [])
    end)
  end

  plug :dispatch
end
