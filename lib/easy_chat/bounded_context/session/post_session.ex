defmodule EasyChat.BoundedContext.Session.PostSession do
  @moduledoc """
  This plug start an user session
  """
  alias EasyChat.BoundedContext.Session.Guardian
  import Plug.Conn

  def init(options), do: options

  def call(conn, _) do
    user_repository = Application.get_env(:easy_chat, :user_repo)
    case user_repository.fetch(conn.body_params) do
      {:ok, user} ->
        response_with_token_pair(user, conn)
      _ ->
        send_resp(conn, 401, Poison.encode!(%{message: "UNAUTHORIZED"}))
    end
  end

  def response_with_token_pair(user, conn) do
    {:ok, access_token, _} =
      Guardian.encode_and_sign(user, %{}, ttl: {5, :minutes})
    {:ok, refresh_token, _} =
      Guardian.encode_and_sign(user, %{}, token_type: "refresh", ttl: {4, :weeks})

    content = %{"refresh_token" => refresh_token, "access_token" => access_token}
    |> Poison.encode!

    conn
    |> resp(200, content)
    |> send_resp
  end
end