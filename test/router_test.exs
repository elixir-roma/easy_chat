defmodule EasyChat.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias EasyChat.Router

  @opts Router.init([])

  test "Every path should return the layout" do
    conn = conn(:get, "/#{random_string()}")

    conn = Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body =~ "body"
  end

  test "Assets should point to static" do
    conn = conn(:get, "/robots.txt")

    conn = Router.call(conn, @opts)

    assert conn.state == :file
    assert conn.status == 200
    assert conn.resp_body =~ "Disallow"

  end

  defp random_string do
    :crypto.strong_rand_bytes(8)
    |> Base.url_encode64
    |> binary_part(0, 8)
  end
end
