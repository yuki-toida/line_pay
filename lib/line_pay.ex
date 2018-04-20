defmodule LinePay do
  alias LinePay.Environment

  @doc """
  オーソリ内訳照会API
  """
  def authorization(transaction_id, order_id) do
    "#{endpoint()}/authorizations?transactionId=#{transaction_id}&orderId=#{order_id}"
    |> HTTPoison.get(headers())
    |> decode()
  end

  @doc """
  決済内訳照会API
  """
  def payment(transaction_id, order_id) do
    "#{endpoint()}?transactionId=#{transaction_id}&orderId=#{order_id}"
    |> HTTPoison.get(headers())
    |> decode()
  end

  @doc """
  決済予約API、成功時19桁の取引番号(TransactionId)が発行される
  """
  def reserve(product_name, amount, order_id, capture, client_type) do
    body = %{
      productName: product_name,
      amount: amount,
      currency: "JPY",
      confirmUrl: confirm_url(client_type, order_id),
      cancelUrl: cancel_url(client_type, order_id),
      orderId: order_id,
      capture: capture
    }
    "#{endpoint()}/request"
    |> HTTPoison.post(Poison.encode!(body), headers())
    |> decode()
  end

  # コールバックURL
  defp confirm_url("browser", order_id), do: "#{Environment.confirm_url_browser}/#{order_id}"
  defp confirm_url("ios", _), do: "#{Environment.confirm_url_ios}"
  defp confirm_url("android", _), do: "#{Environment.confirm_url_android}"

  # キャンセルURL
  defp cancel_url("browser", _), do: ""
  defp cancel_url("ios", _), do: "#{Environment.cancel_url_ios}"
  defp cancel_url("android", _), do: "#{Environment.cancel_url_android}"

  @doc """
  capture: true -> 決済完了状態に更新
  capture: false -> オーソリ状態に更新
  """
  def confirm(transaction_id, amount) do
    body = %{
      amount: amount,
      currency: "JPY"
    }
    "#{endpoint()}/#{transaction_id}/confirm"
    |> HTTPoison.post(Poison.encode!(body), headers())
    |> decode()
  end

  @doc """
  オーソリ状態 → 決済完了状態に更新
  """
  def capture(transaction_id, amount) do
    body = %{
      amount: amount,
      currency: "JPY"
    }
    "#{endpoint()}/authorizations/#{transaction_id}/capture"
    |> HTTPoison.post(Poison.encode!(body), headers())
    |> decode()
  end

  @doc """
  オーソリ状態 -> 無効状態に更新
  """
  def void(transaction_id) do
    "#{endpoint()}/authorizations/#{transaction_id}/void"
    |> HTTPoison.post("", headers())
    |> decode()
  end

  @doc """
  決済完了状態 -> 払い戻し状態に更新
  """
  def refund(transaction_id) do
    "#{endpoint()}/#{transaction_id}/refund"
    |> HTTPoison.post("", headers())
    |> decode()
  end

  def endpoint do
    case Environment.sandbox() do
      true -> "https://sandbox-api-pay.line.me/v2/payments"
      false -> "https://api-pay.line.me/v2/payments"
    end
  end

  defp headers do
    [
      {"Content-Type", "application/json"},
      {"X-LINE-ChannelId", Environment.channel_id()},
      {"X-LINE-ChannelSecret", Environment.channel_secret()}
    ]
  end

  defp decode(response) do
    case response do
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
      {:ok, %HTTPoison.Response{body: body}} -> {:ok, Poison.decode!(body)}
    end
  end
  
end
