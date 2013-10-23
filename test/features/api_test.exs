defmodule ApiTest do
  use AzkAgent.TestCase
  use Dynamo.HTTP.Case

  test "returns OK" do
    {conn, body} = check_api(get "/api")
    assert conn.status == 200
    assert "/apps" == body["_links"] #["apps"]["href"]
    #pp body
    #pp conn.sent_body
    #pp conn.resp_headers["content-type"]
  end
end
