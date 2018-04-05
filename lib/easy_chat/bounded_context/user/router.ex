defmodule EasyChat.BoundedContext.User.Router do
  use Plug.Router
  @moduledoc false

  alias EasyChat.BoundedContext.User.PostUser

  plug :match

  post "/", to: PostUser

  plug :dispatch
end
