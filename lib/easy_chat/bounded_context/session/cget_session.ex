defmodule EasyChat.BoundedContext.Session.CgetSession do
  @moduledoc false

  @repo Application.get_env(:easy_chat, :session_repo)
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    content = Poison.encode! Enum.map(@repo.get_all(), fn {user, _} -> user end)
    conn
    |> resp(200, content)
    |> send_resp
  end
end
