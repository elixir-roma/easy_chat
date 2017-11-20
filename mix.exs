defmodule EasyChat.Mixfile do
  use Mix.Project

  def project do
    [
      app: :easy_chat,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {EasyChat.Application, []}
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 1.1.2"},
      {:plug, "~> 1.4.3"},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:guardian, "~> 1.0"}
    ]
  end
end
