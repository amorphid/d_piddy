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

    test "raises an error when called outside of a module" do
      module = ArgumentError
      pattern = ~r/cannot invoke autoname\/0 outside module/
      function = fn ->
        Code.compile_string("""
          require #{inspect(@module)};
          #{inspect(@module)}.autoname
        """)
      end

      assert_raise(module, pattern, function)
    end
  end

  describe "generating a registry-friendly name by providing a value" do
    test "uses the process group leader" do
      import D.Piddy

      d_piddy_registry = D.Piddy.Registry

      # if you generate a random name, rememeber it!
      # you don't be able to find the pid without the name :)
      any_ol_value = {
        "this name is not very human readable",
        make_ref(),
        :crypto.strong_rand_bytes(10),
        :i_am_a_potato
      }

      d_piddy_registry_key = {any_ol_value, Process.group_leader()}

      registry_key = {d_piddy_registry, d_piddy_registry_key}

      expected = {:via, Registry, registry_key}
      actual = name(any_ol_value)
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
