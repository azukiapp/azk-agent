Dynamo.under_test(AzkAgent.Dynamo)
Dynamo.Loader.enable
ExUnit.start

defmodule AzkAgent.TestCase do
  use ExUnit.CaseTemplate

  using _ do
    quote do
      import unquote(__MODULE__)
    end
  end

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
    :ok
  end

  def check_api(conn) do
    content_type = "application/json; charset=utf-8"
    assert content_type, conn.resp_headers["content-type"]
    { conn, AzkAgent.Utils.JSON.decode(conn.sent_body) }
  end

  # Helper to inspect values
  def pp(value), do: IO.inspect(value)
end
