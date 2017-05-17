defmodule D.PiddyTest do
  use ExUnit.Case, async: true

  @module D.Piddy

  describe "autogenerating a registry-friendly pid name" do
    test "calls 'name/1' w/ module name" do
      require @module

      expected = @module.name(__MODULE__)
      actual = @module.autoname()
      assert expected == actual
    end
  end

  describe "generating a Registry friendly name" do
    test "with a custom value" do
      import D.Piddy

      custom_val = "my custom val"
      expected = {:via, Registry, {D.Piddy.Registry, {custom_val, Process.group_leader()}}}
      actual = name(custom_val)
      assert expected == actual
    end
  end

  describe "looking up a process" do
    defmodule MyServer do
      use GenServer
      import D.Piddy

      def start_link() do
        GenServer.start_link(__MODULE__, [], name: autoname())
      end

      def start_link(value) do
        GenServer.start_link(__MODULE__, [], name: name(value))
      end
    end

    test "that was autonamed uses the process' module name" do
      {:ok, pid} = MyServer.start_link()
      expected = pid
      actual   = D.Piddy.lookup(MyServer)
      assert expected == actual
    end

    test "that was name w/ with a value" do
      value = "<insert creative value here>"
      {:ok, pid} = MyServer.start_link(value)
      expected = pid
      actual   = D.Piddy.lookup(value)
      assert expected == actual
    end

    test "that doesn't exist returns nil" do
      unregistered_name = :this_is_not_the_pid_you_are_looking_for
      expected = nil
      actual   = D.Piddy.lookup(unregistered_name)
      assert expected == actual
    end
  end
end
