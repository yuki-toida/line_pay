defmodule LinePay.Environment do

  def channel_id do
    Application.fetch_env!(:line_pay, :channel_id)
  end
  
  def channel_secret do
    Application.get_env(:line_pay, :channel_secret, System.get_env("CHANNEL_SECRET"))
  end

  def sandbox do
    Application.get_env(:line_pay, :sandbox, true)
  end

  def confirm_url_browser do
    Application.get_env(:line_pay, :confirm_url_browser, nil)
  end

  def confirm_url_ios do
    Application.get_env(:line_pay, :confirm_url_ios, nil)
  end
  
  def confirm_url_android do
    Application.get_env(:line_pay, :confirm_url_android, nil)
  end

  def cancel_url_ios do
    Application.get_env(:line_pay, :cancel_url_ios, nil)
  end

  def cancel_url_android do
    Application.get_env(:line_pay, :cancel_url_android, nil)
  end
end
