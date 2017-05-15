defmodule D.Piddy.NamerTest do
  use ExUnit.Case, async: true

  describe "generating a Registry friendly name" do
    test "automatically" do
      import D.Piddy.Namer

      expected = {:via, Registry, {D.Piddy.Registry, {__MODULE__, Process.group_leader()}}}
      actual = autoname()
      assert expected == actual
    end

    test "with a custom value" do
      import D.Piddy.Namer

      custom_val = "my custom val"

      expected = {:via, Registry, {D.Piddy.Registry, {custom_val, Process.group_leader()}}}
      actual = name(custom_val)
      assert expected == actual
    end
  end
end
