defmodule App.RouterTest do
  use ExUnit.Case
  use Plug.Test

  alias App.Router

  @content "<html><body>Hi!</body></html>"
  @mimetype "text/html"

  @opts Router.init([])

  test "returns welcome" do
    conn =
      :get
      |> conn("/", "")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
  end

  test "returns uploaded" do
    conn =
      :get
      |> conn("/upload?content=#{@content}&mimetype=#{@mimetype}")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 201
  end

  test "returns 404" do
    conn =
      :get
      |> conn("/missing", "")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end


  test "Invoke the App.Router.handle_errors/2" do
    args = %{kind: "kind", reason: "reason", stack: "stack"}
    conn =
      :get
      |> conn("/", "")
      |> Map.put(:status, 500)
      |> Router.handle_errors(args)

    assert conn.resp_body == "Something went wrong"
  end
end
