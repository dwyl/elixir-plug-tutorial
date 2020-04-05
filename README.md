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

You should see output similar to the following:

```
Compiling 3 files (.ex)
Generated app app

22:52:04.719 [info]  Visit: http://localhost:4000
```

Open your web browser and visit: http://localhost:4000

![hello-world](https://user-images.githubusercontent.com/194400/78510862-3b2ca900-7790-11ea-945e-a1d7d81d287f.png)






## Recommended Reading

+ A deeper dive in Elixir's Plug:
https://ieftimov.com/post/a-deeper-dive-in-elixir-plug
