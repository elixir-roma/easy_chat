defmodule EasyChat.BoundedContext.User.Router do
  use Plug.Router
  @moduledoc false

  alias EasyChat.BoundedContext.User.PostUser
  alias EasyChat.BoundedContext.Session.Guardian, as: ECGuardian

  plug :match

  post "/", to: PostUser

  plug :dispatch
end
