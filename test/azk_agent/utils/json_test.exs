defmodule AzkAgent.Utils.JSON.Test do
  use ExUnit.Case
  alias AzkAgent.Utils.JSON

  test "normal encode support" do
    data = [user: "daniel"]
    result = JSON.decode(JSON.encode(data))

    assert data[:user], result["user"]
  end

  test "suport encode HashDict" do
    hash = HashDict.new(user: "foo", name: "Daniel")
    objt = JSON.decode(JSON.encode(hash))

    assert hash[:user], objt["user"]
    assert hash[:name], objt["name"]
  end
end
