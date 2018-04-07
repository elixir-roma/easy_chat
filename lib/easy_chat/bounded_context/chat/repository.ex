defmodule EasyChat.BoundedContext.Chat.Repository do
  @moduledoc false

  defmodule Message do
    @moduledoc false
    defstruct [:sender, :content]
  end

  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def insert(%Message{} = message) do
    Agent.update(__MODULE__, &([message|Enum.take(&1, 100)]))
  end

  def insert(%{sender: sender, content: content}) do
    insert(%Message{sender: sender, content: content})
  end

  def get_all do
    Agent.get __MODULE__, &Enum.reverse/1
  end
end
