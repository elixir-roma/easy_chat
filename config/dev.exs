use Mix.Config

config :easy_chat, EasyChat.BoundedContext.Session.Guardian,
       issuer: "easy_chat",
       secret_key: "728DhhtdjjrgGk5Njz2ws7rhzK0oS7gAv9gTQgCCI+5Zsz9b3la21+DXjTzIU8DV",
       error_handler: EasyChat.BoundedContext.Session.ErrorHandler,
       token_module: Guardian.Token.Jwt

config :easy_chat,
       user_repo: NodeCache
