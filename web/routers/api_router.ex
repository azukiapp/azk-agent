defmodule ApiRouter do
  use Api.BaseRouter

  @root JSON.encode [
    _links: [
      [apps: [ href: "/apps" ]]
    ],
    version: "v0.0.1"
  ]

  get "/" do
    base_conn(conn).resp(200,  @root)
  end
end
