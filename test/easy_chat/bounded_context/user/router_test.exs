defmodule EasyChat.BoundedContext.User.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias EasyChat.BoundedContext.User.Router

  @opts Router.init([])

  test "Post a new user to /" do
    user_json = %{"username" => "new_test_user", "password" => "test_pass"}

    conn = conn(:post, "/", user_json)
    |> Router.call(@opts)

    assert conn.status == 200
    response = conn.resp_body
    |> Poison.decode!

    assert Map.has_key? response, "access_token"
  end
end
