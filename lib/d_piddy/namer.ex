defmodule D.Piddy.Namer do
  @moduledoc false

  #######
  # API #
  #######

  defmacro autoname() do
    quote do
      name(__MODULE__)
    end
  end

  @doc """
  Generates `Registry` friendly pid names.
  """
  def name(val) do
    {:via, Registry, {D.Piddy.Registry, {val, Process.group_leader()}}}
  end
end
