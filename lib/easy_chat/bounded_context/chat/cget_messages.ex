defmodule EasyChat.BoundedContext.Chat.CgetMessage do
  @moduledoc false

  @repo Application.get_env(:easy_chat, :message_repo)
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    content = Poison.encode! @repo.get_all()
    conn
    |> resp(200, content)
    |> send_resp
  end
end
