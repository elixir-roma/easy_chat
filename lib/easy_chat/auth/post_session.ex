defmodule EasyChat.Auth.PostSession do
  @moduledoc """
  This plug start an user session
  """
  alias EasyChat.Auth.Guardian
  import Plug.Conn

  def init(options), do: options

  def call(conn, _) do
    user_repository = Application.get_env(:easy_chat, :user_repo)
    case user_repository.fetch(conn.body_params) do
      {:ok, user} ->
        {:ok, access_token, _} =
          Guardian.encode_and_sign(user, %{}, ttl: {5, :minutes})
        {:ok, refresh_token, _} =
          Guardian.encode_and_sign(user, %{}, token_type: "refresh", ttl: {4, :weeks})
        conn
        |> put_resp_header("authorization", "Bearer #{access_token}")
        |> set_content(refresh_token)
        |> send_resp
      {:error} ->
        send_resp(conn, 401, Poison.encode!(%{message: "UNAUTHORIZED"}))
    end
  end

  defp set_content(conn, token) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> resp(200, Poison.encode! %{refresh_token: token})
  end
end
