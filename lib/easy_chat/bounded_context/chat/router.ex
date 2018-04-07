defmodule EasyChat.BoundedContext.Chat.Router do
  use Plug.Router
  @moduledoc false

  alias EasyChat.BoundedContext.Chat.CgetMessages
  alias EasyChat.BoundedContext.Session.GuardPipeline

  plug :match

  get "/"  do
    conn
    |> GuardPipeline.call([])
    |> CgetMessages.call([])
  end

  plug :dispatch
end
