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