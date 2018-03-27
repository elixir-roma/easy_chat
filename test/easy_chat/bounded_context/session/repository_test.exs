defmodule EasyChat.BoundedContext.Session.RepositoryTest do
  use ExUnit.Case, async: true

  alias EasyChat.BoundedContext.Session.Repository, as: Subject

  test "It should add a tuple rapresenting an user an his websocket pid" do
    Subject.insert {"test", "a websocket pid"}

    assert Enum.member? Subject.get_all(), {"test", "a websocket pid"}
  end

  test "If the user exists, the pid should be upgraded" do
    Subject.insert {"test", "a websocket pid"}
    Subject.insert {"test", "another websocket pid"}

    refute Enum.member? Subject.get_all(), {"test", "a websocket pid"}
    assert Enum.member? Subject.get_all(), {"test", "another websocket pid"}
    
  end

  test "It should remove an entry by pid" do
    Subject.insert {"test", "a websocket pid"}
    Subject.remove  "a websocket pid"

    refute Enum.member? Subject.get_all(), {"test", "a websocket pid"}
  end
end
