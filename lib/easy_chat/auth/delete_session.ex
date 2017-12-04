defmodule EasyChat.Auth.DeleteSession do
  @moduledoc false

  alias EasyChat.Auth.Guardian
  alias EasyChat.Auth.Guardian.Plug, as: Gplug
  import Plug.Conn

  def init(options), do: options

  def call(conn, _) do
    case Gplug.current_token(conn) do
      nil ->
        send_resp(conn, 410, Poison.encode!(%{message: "GONE"}))
      token ->
        Guardian.revoke(token)
        conn
        |> send_resp(204, "")
    end
  end
end
