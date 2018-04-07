defmodule EasyChat.BoundedContext.Chat.WebsocketTest do
  use ExUnit.Case, async: true

  alias EasyChat.BoundedContext.Chat.Websocket, as: Subject
  alias EasyChat.BoundedContext.Session.RepositoryMock, as: SessionRepo
  alias EasyChat.BoundedContext.Chat.RepositoryMock, as: MessageRepo
  alias EasyChat.BoundedContext.Session.GuardianMock, as: Auth

  test "It should discard a message with a wrong token" do
    SessionRepo.start_link([])
    MessageRepo.start_link([])
    Auth.start_link([])
    SessionRepo.subscribe()
    Auth.stub({:error, "dunno"})

    data = %{"jwt" => "invalid_jwt"}
    assert {:ok, [], %{}} = Subject.websocket_handle({:text, Poison.encode! data}, [], %{})

    refute_receive {_any_messages, SessionRepo}

  end

  test "It should join the chat with a right token, and all sessions should be notified" do
    SessionRepo.start_link([])
    MessageRepo.start_link([])
    Auth.start_link([])
    SessionRepo.subscribe()
    SessionRepo.stub([{"other_user", self()}])
    Auth.stub({:ok, "testuser", %{}})
    Auth.stub({:ok, []})

    data = %{"jwt" => "valid_jwt", "command" => "join"}

    assert {:ok, [], %{}} = Subject.websocket_handle({:text, Poison.encode! data}, [], %{})

    assert_receive {{:insert, {"testuser" , _}}, SessionRepo}
    assert_receive {:join, "testuser"}
  end

  test "It should send a message to all sessions" do
    SessionRepo.start_link([])
    MessageRepo.start_link([])
    Auth.start_link([])
    SessionRepo.subscribe()
    MessageRepo.subscribe()
    SessionRepo.stub([{"other_user", self()}])
    Auth.stub({:ok, "testuser", %{}})
    Auth.stub({:ok, []})

    data = %{"jwt" => "valid_jwt", "command" => "msg", "content" => "test message"}

    assert {:ok, [], %{}} = Subject.websocket_handle({:text, Poison.encode! data}, [], %{})

    refute_receive {{:insert, _}, SessionRepo}
    assert_receive {{:insert, _}, MessageRepo}
    assert_receive {:msg, %{sender: "testuser", content: "test message"}}
  end
end
