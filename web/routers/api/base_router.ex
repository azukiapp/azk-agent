defmodule Api.BaseRouter do
  defmacro __using__(_) do
    quote do
      use Dynamo.Router
      alias AzkAgent.Utils.JSON

      import unquote(__MODULE__)
    end
  end

  def base_conn(conn) do
    conn
      .resp_content_type("application/json")
      .resp_charset("utf-8")
  end
end
