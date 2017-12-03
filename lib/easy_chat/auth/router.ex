defmodule EasyChat.Auth.Router do
  use Plug.Router
  @moduledoc false

  alias EasyChat.Auth.PostSession

  plug :match
  plug :dispatch

  post "/session", to: PostSession
end
