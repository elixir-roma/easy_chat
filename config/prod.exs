use Mix.Config

config :easy_chat, EasyChat.Auth.Guardian,
       issuer: "easy_chat",
       secret_key: {:system, "EASY_CHAT_SECRET_KEY"},
       error_handler: EasyChat.Auth.ErrorHandler,
       token_module: Guardian.Token.Jwt

config :easy_chat,
       user_repo: EasyChat.User.Repository