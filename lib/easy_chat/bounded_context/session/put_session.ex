defmodule EasyChat.BoundedContext.Session.PutSession do
  @moduledoc false

  alias EasyChat.BoundedContext.Session.Guardian
  alias EasyChat.BoundedContext.Session.Guardian.Plug, as: Gplug
  import Plug.Conn

  def init(options) when is_list(options) do
    init(Enum.into options, %{})
  end

  def init(options) when is_map(options) do
    if Map.has_key? options, :type do
      options
    else
      Map.put(options, :type, "access")
    end
  end

  def call(conn, %{type: "refresh"}) do
    case Gplug.current_token(conn) do
      nil ->
        send_resp(conn, 401, Poison.encode!(%{message: "UNAUTHORIZED"}))
      token ->
        {:ok, _, {new_token, _}} =
          Guardian.exchange(token, "refresh", "access", ttl: {5, :minutes})
        conn
        |> put_resp_header("authorization", "Bearer #{new_token}")
        |> send_resp(204, "")
    end
  end

  def call(conn, %{type: "access"}) do
    case Gplug.current_token(conn) do
      nil ->
        send_resp(conn, 401, Poison.encode!(%{message: "UNAUTHORIZED"}))
      token ->
        {:ok, new_token} = Guardian.refresh(token, ttl: {5, :minutes})
        conn
        |> put_resp_header("authorization", "Bearer #{new_token}")
    end
  end

end
