defmodule Portal do
  @moduledoc """
  Documentation for Portal.
  """
  defstruct [:left, :right]

  @doc """
  Starts transferring `data` from `left` to `right`
  """
  def transfer(left, right, data) do
    for i <- data do
      Portal.Door.push(left, i)
    end

    %Portal{left: left, right: right}
  end

  def push_right(portal) do
    case Portal.Door.pop(portal.left) do
      :error -> :ok
      {:ok, h} -> Portal.Door.push(portal.right, h)
    end

    portal
  end

  def shoot(colour) do
    Supervisor.start_child(Portal.Supervisor, [colour])
  end
end

defimpl Inspect, for: Portal do
  def inspect(%Portal{left: left, right: right}, _) do
    left_door = inspect(left)
    right_door = inspect(right)

    left_data = inspect(Enum.reverse(Portal.Door.get(left)))
    right_data = inspect(Portal.Door.get(right))

    max = max(String.length(left_door), String.length(left_data))

    """
      #Portal<
        #{String.pad_leading(left_door, max)} <=> #{right_door}
        #{String.pad_leading(left_data, max)} <=> #{right_data}
      >
    """
  end
end
