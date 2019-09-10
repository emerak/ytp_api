MoneyRails.configure do |config|

  # set the default currency
  config.default_currency = :mxn
  config.default_format = {
    symbol: nil,
    no_cents_if_whole: true
  }
end
