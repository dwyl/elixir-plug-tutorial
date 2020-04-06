# Elixir Plug Tutorial

Re-doing the Elixir Plug tutorial to update knowledge:
https://elixirschool.com/en/lessons/specifics/plug

Create a new Elixir/OTP project with supervision tree:

```
mix new app --sup
cd app
```

That will create a project directory with the following files:

```
├── LICENSE
├── README.md
├── lib
│   ├── app
│   │   └── application.ex
│   └── app.ex
├── mix.exs
└── test
    ├── app_test.exs
    └── test_helper.exs
```

### Dependencies

Plug is the system for handling HTTP requests
but it is not an HTTP server,
for that we need to add
[**`Cowboy`**](https://github.com/ninenines/cowboy).

Open your `mix.exs` file and locate the `defp deps do` section.
Add the following line to the list of dependencies:

```elixir
{:plug_cowboy, "~> 2.1"}
```

Once you've saved your file,
it should looke like this:
[`mix.exs#L25`](https://github.com/nelsonic/elixir-plug-tutorial/blob/2857e49409bb3e21f699a165631701e7ca1323e3/mix.exs#L25)

Install the dependencies by running the following command:

```sh
mix deps.get
```

That will create a
[`mix.lock`](https://github.com/nelsonic/elixir-plug-tutorial/blob/0cb4baeba23c7440b2d16ca89721cbe7338f1d09/mix.lock)
file that lists the exact version of dependencies used.


### Hello World

Create a new file with the path: `lib/app/hello_world.ex`

Add the following code to the file:
```elixir
defmodule App.HelloWorld do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello World!\n")
  end
end
```

`init/1` and `call/2` are required functions for a Plug. <br />
`init/1` is invoked when the application is initialised. <br />
`call/2` is invoked as the handler for all requests.


We cannot _run_ this file yet,
we need to add it to list of "children"
in the `start/2` function
in `lib/app/application.ex`.

Open your `lib/app/application.ex` file
and replace the contents with the following code:

```elixir
defmodule App.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications

  use Application
  require Logger

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: App.HelloWorld, options: [port: 4000]}
    ]

    Logger.info("Visit: http://localhost:4000")
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: App.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

Your `application.ex` file should look like this:
[`lib/app/application.ex`](https://github.com/nelsonic/elixir-plug-tutorial/blob/master/lib/app/application.ex)



Once the file is saved, run the app with the following command:

```
mix run --no-halt
```

> **Note**: to shut down the server,
use the <kbd>ctrl + c</kbd> keyboard shortcut.

You should see output similar to the following:

```
Compiling 3 files (.ex)
Generated app app

22:52:04.719 [info]  Visit: http://localhost:4000
```

Open your web browser and visit: http://localhost:4000

![hello-world](https://user-images.githubusercontent.com/194400/78510862-3b2ca900-7790-11ea-945e-a1d7d81d287f.png)


### Plug Router

Create a new file: `lib/app/router.ex`
Add the following code to it:

```elixir
defmodule App.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Hello Elixir Plug!")
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end

```

# Todo: add explanation



Open the `application.ex` file and replace the line:

```elixir
{Plug.Cowboy, scheme: :http, plug: App.HelloWorld, options: [port: 4000]}
```

With:

```elixir
{Plug.Cowboy, scheme: :http, plug: App.Router, options: [port: 4000]}
```

`App.HelloWorld` -> `App.Router`


```
mix run --no-halt
```


![hello-elixir-plug](https://user-images.githubusercontent.com/194400/78511381-19352580-7794-11ea-809d-f5b92028e3eb.png)


## Verify Request Plug

The next step in the ElixirSchohol instructions is:
https://elixirschool.com/en/lessons/specifics/plug/#adding-another-plug

Create a new file with the path: `lib/app/verify_request.ex`

Visit:
http://localhost:4000/upload

Firefox shows a blank screen with no content:
![no-content](https://user-images.githubusercontent.com/194400/78546716-d1df8100-77f5-11ea-87c1-47cd8ae64ad9.png)


Google Chrome shows the following `HTTP ERROR 500`:

![500-error](https://user-images.githubusercontent.com/194400/78551239-4833b180-77fd-11ea-836e-ae4847f72056.png)



Terminal output:
```
10:38:03.777 [error] #PID<0.339.0> running App.Router (connection #PID<0.338.0>, stream id 1) terminated
Server: localhost:4000 (http)
Request: GET /upload
** (exit) an exception was raised:
    ** (App.Plug.VerifyRequest.IncompleteRequestError)
        (app 0.1.0) lib/app/verify_request.ex:23: App.Plug.VerifyRequest.verify_request!/2
        (app 0.1.0) lib/app/verify_request.ex:13: App.Plug.VerifyRequest.call/2
        (app 0.1.0) lib/app/router.ex:1: App.Router.plug_builder_call/2
        (plug_cowboy 2.1.2) lib/plug/cowboy/handler.ex:12: Plug.Cowboy.Handler.init/2
        (cowboy 2.7.0) /elixir-plug-tutorial/deps/cowboy/src/cowboy_handler.erl:41: :cowboy_handler.execute/2
        (cowboy 2.7.0) /elixir-plug-tutorial/deps/cowboy/src/cowboy_stream_h.erl:320: :cowboy_stream_h.execute/3
        (cowboy 2.7.0) /elixir-plug-tutorial/deps/cowboy/src/cowboy_stream_h.erl:302: :cowboy_stream_h.request_process/3
        (stdlib 3.11.2) proc_lib.erl:249: :proc_lib.init_p_do_apply/3
```

This is **_horrible_ UX**. 😕 <br />
(_I will **definitely** be improving on this!_)

http://127.0.0.1:4000/upload?content=thing1&mimetype=thing2

![uploaded](https://user-images.githubusercontent.com/194400/78546836-fdfb0200-77f5-11ea-82b6-9a2a1b332300.png)


## Testing

Create a file with the following path:
`test/app/router_test.exs`

Add the following code to the file:

```elixir
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
end
```

Run the tests with the command:

```
mix test
```

You should expect to see the following output:

```
.....

Finished in 0.03 seconds
1 doctest, 4 tests, 0 failures
```


## Error Handling


As noted above, the UX for an unsuccessful request is rather bad.

Open the `router.ex` file and add the following line near the top:

```elixir
use Plug.ErrorHandler
```

Then at the _end_ of the file add the following function definition:

```elixir
defp handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
  IO.inspect(kind, label: :kind)
  IO.inspect(reason, label: :reason)
  IO.inspect(stack, label: :stack)
  send_resp(conn, conn.status, "Something went wrong")
end
```

Your `router.ex` file should now look like this:
[`lib/app/router.ex`](https://github.com/nelsonic/elixir-plug-tutorial/blob/915ef0e15bba4d887a0bb446685b264ce590bb8c/lib/app/router.ex)


Running the app now:
```
mix run --no-halt
```

Visiting the `/upload` path in your browser:
http://localhost:4000/upload

You will now see:

![something-went-wrong](https://user-images.githubusercontent.com/194400/78572787-d02ab300-781f-11ea-9acc-38bfb1da7883.png)

In your terminal, you will see the following output:

```
kind: :error
reason: %App.Plug.VerifyRequest.IncompleteRequestError{message: "", plug_status: 400}
stack: [
  {App.Plug.VerifyRequest, :verify_request!, 2,
   [file: 'lib/app/verify_request.ex', line: 23]},
  {App.Plug.VerifyRequest, :call, 2,
   [file: 'lib/app/verify_request.ex', line: 13]},
  {App.Router, :plug_builder_call, 2, [file: 'lib/app/router.ex', line: 1]},
  {App.Router, :call, 2, [file: 'lib/plug/error_handler.ex', line: 65]},
  {Plug.Cowboy.Handler, :init, 2,
   [file: 'lib/plug/cowboy/handler.ex', line: 12]},
  {:cowboy_handler, :execute, 2,
   [
     file: '/elixir-plug-tutorial/deps/cowboy/src/cowboy_handler.erl',
     line: 41
   ]},
  {:cowboy_stream_h, :execute, 3,
   [
     file: '/elixir-plug-tutorial/deps/cowboy/src/cowboy_stream_h.erl',
     line: 320
   ]},
  {:cowboy_stream_h, :request_process, 3,
   [
     file: '/elixir-plug-tutorial/deps/cowboy/src/cowboy_stream_h.erl',
     line: 302
   ]}
]
```





## Recommended Reading


+ Elixir School Plug:
https://elixirschool.com/en/lessons/specifics/plug/
+ Getting started with Plug in Elixir
https://www.brianstorti.com/getting-started-with-plug-elixir/
+ A deeper dive in Elixir's Plug:
https://ieftimov.com/post/a-deeper-dive-in-elixir-plug
+ Elixir: Building a Small JSON Endpoint With Plug, Cowboy and Poison
https://dev.to/jonlunsford/elixir-building-a-small-json-endpoint-with-plug-cowboy-and-poison-1826
+ Serving Plug: Building an Elixir HTTP server from scratch
https://blog.appsignal.com/2019/01/22/serving-plug-building-an-elixir-http-server.html
+ Testing Elixir Plugs (2016):
https://thoughtbot.com/blog/testing-elixir-plugs
