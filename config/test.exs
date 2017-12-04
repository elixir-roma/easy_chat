use Mix.Config

config :easy_chat, EasyChat.BoundedContext.Session.Guardian,
  issuer: "easy_chat",
  secret_key: "test",
  error_handler: EasyChat.BoundedContext.Session.ErrorHandler,
  token_module: Guardian.Token.Jwt

config :easy_chat,
  user_repo: EasyChat.BoundedContext.User.Repository
