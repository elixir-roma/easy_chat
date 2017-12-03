defmodule EasyChat.Auth.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias EasyChat.Auth.Router

  @opts Router.init([])

  test "Post a new session to /api/auth/session should autenticate an user" do
    conn = conn(:post, "/session", %{"username" => "test_user", "password" => "test_pass"})
    conn = Router.call(conn, @opts)

    assert conn.status == 200
    assert [auth_header|_] = get_resp_header(conn, "authentication")
    assert String.contains? auth_header, "Bearer"
    assert  String.contains? conn.resp_body, "refresh_token"
  end

end