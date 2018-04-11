defmodule EasyChat.BoundedContext.Chat.Repository do
  @moduledoc false

  defmodule Message do
    @moduledoc false
    defstruct [:sender, :content]
  end

  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def insert_c(%Message{} = message) do
    Agent.update(__MODULE__, &([message|Enum.take(&1, 100)]))
  end

  def insert_c(%{sender: sender, content: content}) do
    insert_c(%Message{sender: sender, content: content})
  end

  def get_all_c do
    Agent.get __MODULE__, &Enum.reverse/1
  end

  # to get the node weight
  def count do
    {:messages_count, Agent.get(__MODULE__, fn ls -> length(ls) end)}
  end

end
