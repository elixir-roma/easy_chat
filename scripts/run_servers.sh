#!/usr/bin/env bash


HTTP_PORT=8080 elixir --sname easy_chat80 -S mix run --no-halt &
HTTP_PORT=8081 elixir --sname easy_chat81 -S mix run --no-halt &
HTTP_PORT=8082 elixir --sname easy_chat82 -S mix run --no-halt &
HTTP_PORT=8083 elixir --sname easy_chat83 -S mix run --no-halt &