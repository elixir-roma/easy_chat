defmodule EasyChat.BoundedContext.Chat.CgetMessages do
  @moduledoc false

  @repo Application.get_env(:easy_chat, :message_repo)
  import Plug.Conn
  require Logger
  def init(opts), do: opts

  def call(conn, _) do
    content = Poison.encode! @repo.get_all_c()
    conn
    |> resp(200, content)
    |> send_resp
  end
end
