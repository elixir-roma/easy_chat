defmodule EasyChat.BoundedContext.Session.Cget do
  @moduledoc false

  @repo Application.get_env(:easy_chat, :session_repo)
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    Poison.encode! @repo.get_all()
  end
end
