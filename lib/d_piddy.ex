defmodule D.Piddy do
  @moduledoc """
  Documentation for D.Piddy.
  """

  @doc """
  Calls `&name/1` with `__MODULE__` as the value.
  """
  defmacro autoname() do
    quote do
      case __MODULE__ do
        module when not is_nil(module) ->
          unquote(__MODULE__).name(module)
        nil ->
          raise ArgumentError, "cannot invoke autoname/0 outside module"
      end
    end
  end

  @doc """
  Generates a `Registry` friendly pid name.  The name itself is not meant to be human readable.

  ## Example
      iex> import D.Piddy
      D.Piddy
      iex> name("my pid name")
      {:via, Registry, {D.Piddy.Registry, {"my pid name", #PID<0.50.0>}}}
  """
  def name(value) do
    module = D.Piddy.Registry
    pid    = Process.group_leader()
    name   = {module, {value, pid}}
    {:via, Registry, name}
  end

  @doc """
  Finds a process in `D.Piddy.Registry` based on the value provided.  If the pid is not found, `nil` is returned

  ## Example
      iex> D.Piddy.lookup("<pid in registry>")
      #PID<0.50.0>
      iex> D.Piddy.lookup("<pid NOT in registry>")
      nil
  """
  def lookup(value) do
    registry     = D.Piddy.Registry
    group_leader = Process.group_leader()

    case Registry.lookup(registry, {value, group_leader}) do
      [{pid, nil}] -> pid
      []           -> nil
    end
  end
end
