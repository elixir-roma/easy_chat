defmodule EasyChat.BoundedContext.Chat.WebsocketTest do
  use ExUnit.Case, async: true

  alias EasyChat.BoundedContext.Chat.Websocket, as: Subject
  alias EasyChat.BoundedContext.Session.RepositoryMock, as: Repo
  alias EasyChat.BoundedContext.Session.GuardianMock, as: Auth

  test "It should discard a message with a wrong token" do
    Repo.start_link([])
    Auth.start_link([])
    Repo.subscribe()
    Auth.stub({:error, "dunno"})

    data = %{"jwt" => "invalid_jwt"} 
    assert {:ok, %{}} = Subject.websocket_handle({:text, Poison.encode! data}, %{})

    refute_receive {_any_messages, Repo}

  end

  test "It should join the chat with a right token" do
    Repo.start_link([])
    Auth.start_link([])
    Repo.subscribe()
    Auth.stub("testuser")
    Auth.stub({:ok, []})

    data = %{"jwt" => "valid_jwt", "command" => "join"}

    assert {:ok, %{}} = Subject.websocket_handle({:text, Poison.encode! data}, %{})

    assert_receive {{:insert, {"testuser" , _}}, Repo}
  end

  
end
