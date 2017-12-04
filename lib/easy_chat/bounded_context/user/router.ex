defmodule EasyChat.BoundedContext.User.Router do
  use Plug.Router
  @moduledoc false

  alias EasyChat.BoundedContext.User.PostUser
  alias EasyChat.BoundedContext.Session.Guardian, as: ECGuardian

  plug :match

  plug Guardian.Plug.Pipeline, module: ECGuardian
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.LoadResource, allow_blank: true

  plug :dispatch

  post "/", to: PostUser
end
