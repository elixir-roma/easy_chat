use Mix.Config

config :easy_chat, EasyChat.BoundedContext.Session.Guardian,
  issuer: "easy_chat",
  secret_key: {:system, "EASY_CHAT_SECRET_KEY"},
  error_handler: EasyChat.BoundedContext.Session.ErrorHandler,
  token_module: Guardian.Token.Jwt

config :easy_chat,
       session_repo: NodeCache,
       auth: EasyChat.BoundedContext.Session.Guardian,
       user_repo: NodeCache,
       message_repo: NodeCache


