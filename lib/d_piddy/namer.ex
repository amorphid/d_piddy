defmodule D.Piddy.Namer do
  @moduledoc false

  #######
  # API #
  #######

  @doc false
  def name(value) do
    module = D.Piddy.Registry
    pid    = Process.group_leader()
    name   = {module, {value, pid}}
    {:via, Registry, name}
  end
end
