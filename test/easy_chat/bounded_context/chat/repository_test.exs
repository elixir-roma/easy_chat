defmodule EasyChat.BoundedContext.Chat.RepositoryTest do
  use ExUnit.Case, async: true

  alias EasyChat.BoundedContext.Chat.Repository, as: Subject
  alias EasyChat.BoundedContext.Chat.Repository.Message

  test "It should store a message" do
    Subject.insert %Message{sender: "testuser", message: "My first message"}

    assert List.last(Subject.get_all()) == %Message{sender: "testuser", message: "My first message"}
  end

  test "It should preserve the order" do
    Subject.insert %Message{sender: "testuser", message: "My first message"}
    Subject.insert %Message{sender: "testuser", message: "My second message"}

    assert Enum.take(Subject.get_all(), -2) == [%Message{sender: "testuser", message: "My first message"},
                                               %Message{sender: "testuser", message: "My second message"}]
  end
end
