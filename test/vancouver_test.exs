defmodule VancouverTest do
  use ExUnit.Case
  doctest Vancouver

  test "greets the world" do
    assert Vancouver.hello() == :world
  end
end
