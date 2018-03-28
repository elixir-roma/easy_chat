defmodule EasyChat.BoundedContext.Session.Router do
  use Plug.Router
  @moduledoc false

  alias EasyChat.BoundedContext.Session.PostSession
  alias EasyChat.BoundedContext.Session.CgetSession
  alias EasyChat.BoundedContext.Session.GuardPipeline

  plug :match

  post "/", to: PostSession

  get "/"  do
    conn
    |> GuardPipeline.call([])
    |> CgetSession.call([])
  end
plug :dispatch
end
