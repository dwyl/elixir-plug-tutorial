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