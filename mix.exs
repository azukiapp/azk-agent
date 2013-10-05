defmodule AzkAgent.Mixfile do
  use Mix.Project

  def project do
    [ app: :azk_agent,
      version: "0.0.1",
      dynamos: [AzkAgent.Dynamo],
      compilers: [:elixir, :dynamo, :app],
      env: [prod: [compile_path: "ebin"]],
      compile_path: "tmp/#{Mix.env}/azk_agent/ebin",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:cowboy, :dynamo],
      mod: { AzkAgent, [] } ]
  end

  defp deps do
    [
      { :cowboy, github: "extend/cowboy" },
      { :dynamo, github: "elixir-lang/dynamo", tag: "elixir-0.10.2" },
      { :uuid, github: "avtobiff/erlang-uuid", tag: "v0.4.4" },
      { :jsx, github: "talentdeficit/jsx", compile: "rebar compile" },
    ]
  end
end
