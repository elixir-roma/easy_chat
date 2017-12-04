defmodule EasyChat.Auth.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias EasyChat.Auth.Router

  @opts Router.init([])

  test "Post a new session to /api/auth/session should autenticate an user" do
    conn = conn(:post, "/session", %{"username" => "test_user", "password" => "test_pass"})
    conn = Router.call(conn, @opts)

    assert conn.status == 200
    assert [auth_header|_] = get_resp_header(conn, "authorization")
    assert String.contains? auth_header, "Bearer"
    assert  String.contains? conn.resp_body, "refresh_token"
  end

  test "Refresh a session should return an access token" do
    conn = conn(:post, "/session", %{"username" => "test_user", "password" => "test_pass"})
    |> Router.call(@opts)

    body = conn.resp_body
    |> Poison.decode!

    conn = conn(:put, "/refresh")
    |> put_req_header("authorization", "Bearer #{body["refresh_token"]}")

    conn = Router.call(conn, @opts)

    assert [auth_header|_] = get_resp_header(conn, "authorization")
    assert [_, token] = String.split auth_header
    assert {:ok, %{"typ" => "access"}} = EasyChat.Auth.Guardian.decode_and_verify(token)
  end
end
