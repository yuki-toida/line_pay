# LINE Pay
simple HTTP client for [LINE Pay](https://line.me/ja/pay/).

## Installation
```elixir
def deps do
  [
    {:line_pay, "~> 0.1.0"}
  ]
end
```

## Configuration
```elixir
use Mix.Config

config :line,
  channel_id: 999999999,
  channel_secret: "YOUR CHANNEL SECRET",
  sandbox: true,
  confirm_url_browser: "",
  confirm_url_ios: "",
  confirm_url_android: "",
  cancel_url_ios: "",
  cancel_url_android: ""
  
```
sandbox: default value is `true`
channel_secret: you can use environment variables.

```bash
export CHANNEL_SECRET="YOUR CHANNEL SECRET"
```

## License
MIT