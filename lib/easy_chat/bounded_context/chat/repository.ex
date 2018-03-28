defmodule EasyChat.BoundedContext.Chat.Repository do
  @moduledoc false

  defmodule Message do
    @moduledoc false
    defstruct [:sender, :message]
  end

  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def insert(%Message{} = message) do
    Agent.update(__MODULE__, &([message|Enum.take(&1, 100)]))
  end

  def get_all do
    Agent.get __MODULE__, &Enum.reverse/1
  end
end
