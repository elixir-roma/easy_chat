defmodule EasyChat.Auth.Guardian do
  @moduledoc false

  alias EasyChat.User.Model, as: User
  use Guardian, otp_app: :easy_chat

  def subject_for_token(%User{username: username}, _claims) do
    {:ok, username}
  end

  def resource_from_claims(claims) do
    {:ok, %User{username: claims["sub"]}}
  end
end
