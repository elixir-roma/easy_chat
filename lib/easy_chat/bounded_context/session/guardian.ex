defmodule EasyChat.BoundedContext.Session.Guardian do
  @moduledoc false

  use Guardian, otp_app: :easy_chat

  def subject_for_token(username, _claims) do
    {:ok, username}
  end

  def resource_from_claims(claims) do
    {:ok, claims["sub"]}
  end
end
