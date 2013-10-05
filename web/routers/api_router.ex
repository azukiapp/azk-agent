defmodule ApiRouter do
  use BaseRouter

  @root :jsx.encode([
    _links: [
      [authentication: [ href: "/authetication" ]],
      [apps: [ href: "/apps" ]]
    ],
    version: "v0.0.1"
  ])

  get "/" do
    base_conn(conn)
      .resp(200,  @root)
  end
end
