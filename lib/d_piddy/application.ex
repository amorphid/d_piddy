defmodule D.Piddy.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Registry, [:unique, D.Piddy.Registry])
    ]

    opts = [strategy: :one_for_one, name: D.Piddy.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
