defmodule EasyChat.BoundedContext.User.PostUser do
  @moduledoc """
  This plug start an user session
  """
  alias EasyChat.BoundedContext.Session.PostSession, as: SessionContext
  import Plug.Conn

  def init(options), do: options

  def call(conn, _) do
    user_repository = Application.get_env(:easy_chat, :user_repo)
    case user_repository.insert(conn.body_params) do
      {:ok, user} ->
        SessionContext.response_with_token_pair(user, conn)
      _ ->
        send_resp(conn, 409, Poison.encode!(%{message: "CONFLICT"}))
    end
  end
end
