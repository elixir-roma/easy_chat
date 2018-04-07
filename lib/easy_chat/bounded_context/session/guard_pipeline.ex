defmodule EasyChat.BoundedContext.Session.GuardPipeline do
  use Plug.Builder
  @moduledoc false

  alias EasyChat.BoundedContext.Session.Guardian, as: ECGuardian
  alias EasyChat.BoundedContext.Session.ErrorHandler, as: EH

  plug Guardian.Plug.Pipeline, module: ECGuardian, error_handler: EH
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.LoadResource
  plug Guardian.Plug.EnsureAuthenticated
end
