defmodule AzkAgent.Utils.Representer.Test do
  use ExUnit.Case

  defmodule OrderRepresenter do
    use AzkAgent.Utils.Representer

    property :currency
    property :status
    property :total

    link :self do
      "/orders/#{represented[:id]}"
    end
  end

  test "return a valid json representation" do
    result = OrderRepresenter.build([])
    assert :jsx.is_json(result)
  end

  test "return a property if is maped" do
    result = :jsx.decode(OrderRepresenter.build([ status: "shiped"]))
    assert "shiped", result["status"]
  end

  test "not return a unmaped property" do
    order  = [ status: "shiped", user: 1 ]
    result = :jsx.decode(OrderRepresenter.build(order))
    assert "shiped", result["status"]
    refute ListDict.has_key?(result, "user")
  end

  test "take propery with data is a enumarable" do
    order  = [ status: "shiped" ]
    result = :jsx.decode(OrderRepresenter.build(order))
    assert "shiped", result["status"]

    order  = [{"status", "shiped"}]
    result = :jsx.decode(OrderRepresenter.build(order))
    assert "shiped", result["status"]

    order  = HashDict.new([{"status", "shiped"}])
    result = :jsx.decode(OrderRepresenter.build(order))
    assert "shiped", result["status"]
  end

  test "return a self link" do
    order  = [ id: 10 ]
    result = :jsx.decode(OrderRepresenter.build(order))

    assert Dict.has_key?(result, "_links")
    assert Dict.has_key?(result["_links"], "self")
    assert Dict.equal?(result["_links"]["self"], [ {"href", "/orders/10"} ])
  end

  defrecord CustomRecord, id: nil, status: "shiped"
  test "support presenter generator to custom record" do
    record = CustomRecord.new(id: "11")
    result = :jsx.decode(OrderRepresenter.build(record))

    assert result["status"] == record.status
    assert Dict.equal?(result["_links"]["self"], [ {"href", "/orders/#{record.id}"} ])
  end
end
