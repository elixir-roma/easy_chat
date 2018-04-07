defmodule EasyChat.BoundedContext.Session.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias EasyChat.BoundedContext.Session.Router
  alias EasyChat.BoundedContext.User.Repository, as: Repo
  alias EasyChat.BoundedContext.Session.RepositoryMock, as: MockedSessionRepo

  @opts Router.init([])

  test "Post a new session to / should autenticate an user" do

    Repo.insert(%{"username" => "test_user", "password" => "test_pass"})

    user_json = %{"username" => "test_user", "password" => "test_pass"}

    conn = :post
    |> conn("/", user_json)
    |> Router.call(@opts)

    assert conn.status == 200
    response = conn.resp_body
    |> Poison.decode!

    assert Map.has_key? response, "access_token"
  end

  test "Post a new session to / should return 401 if the user does not exists" do
    conn = :post
    |> conn("/", %{"username" => "unexistent_user",
                    "password" => "test_pass"})
    |> Router.call(@opts)

    assert conn.status == 401
  end

#  test "Get / should return 401 without a token" do

#    MockedSessionRepo.start_link([])
#    MockedSessionRepo.stub([{"other_user", self()}])

#    conn = :get
#    |> conn("/")
#    |> Router.call(@opts)

#    assert conn.status == 401
#  end

end
