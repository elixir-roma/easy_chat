#!/usr/bin/env bash


HTTP_PORT=8080 iex  --sname easy_chat80 -S mix
HTTP_PORT=8081 iex  --sname easy_chat81 -S mix
HTTP_PORT=8082 iex  --sname easy_chat82 -S mix
HTTP_PORT=8083 iex  --sname easy_chat83 -S mix



```
Node.connect(:easy_chat80@mac)
```