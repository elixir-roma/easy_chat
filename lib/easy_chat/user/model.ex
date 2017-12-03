defmodule EasyChat.User.Model do
  @moduledoc """
  This module expose a struct rapresenting an user
  """

  @enforce_keys [:username]

  defstruct [:username, :password_hash]
end
