defmodule EasyChat.BoundedContext.Session.Router do
  use Plug.Router
  @moduledoc false

  alias EasyChat.BoundedContext.Session.PostSession
  alias EasyChat.BoundedContext.Session.PutSession
  alias EasyChat.BoundedContext.Session.Guardian, as: ECGuardian

  plug :match

  plug Guardian.Plug.Pipeline, module: ECGuardian
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.LoadResource, allow_blank: true

  plug :dispatch

  post "/", to: PostSession
  put "/refresh", to: PutSession, init_opts: [type: "refresh"]
end
