defmodule EasyChat.User.StubRepository do
  alias EasyChat.User.Model, as: User
  @moduledoc """
  This module simulate an user repository
  """

  def fetch(_) do
    {:ok, %User{username: "test_user"}}
  end
end
