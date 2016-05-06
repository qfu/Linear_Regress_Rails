json.array!(@stocks) do |stock|
  json.extract! stock, :id, :symbol, :score
  json.url stock_url(stock, format: :json)
end
