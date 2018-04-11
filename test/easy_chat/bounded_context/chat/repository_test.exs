defmodule EasyChat.BoundedContext.Chat.RepositoryTest do
  use ExUnit.Case, async: true

  alias EasyChat.BoundedContext.Chat.Repository, as: Subject
  alias EasyChat.BoundedContext.Chat.Repository.Message

  test "It should store a message" do
    Subject.insert_c %Message{sender: "testuser", content: "My first message"}

    assert List.last(Subject.get_all_c()) == %Message{sender: "testuser", content: "My first message"}
  end

  test "It should preserve the order" do
    Subject.insert_c %Message{sender: "testuser", content: "My first message"}
    Subject.insert_c %Message{sender: "testuser", content: "My second message"}

    assert Enum.take(Subject.get_all_c(), -2) == [
             %Message{sender: "testuser", content: "My first message"},
             %Message{sender: "testuser", content: "My second message"}]
  end
end
