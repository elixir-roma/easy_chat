use Mix.Config

config :easy_chat, EasyChat.Auth.Guardian,
       issuer: "easy_chat",
       secret_key: "test"

config :easy_chat,
       user_repo: EasyChat.User.Repository