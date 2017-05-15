defmodule D.Piddy.NamerTest do
  use ExUnit.Case, async: true

  test "pattern of name" do
    alias D.Piddy.Namer

    module = D.Piddy.Registry
    value  = "look ma, no hands"
    pid    = Process.group_leader()
    name   = {module, {value, pid}}

    assert {:via, Registry, name} == Namer.name(value)
  end
end
