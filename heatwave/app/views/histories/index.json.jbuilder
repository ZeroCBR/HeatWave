json.array!(@histories) do |history|
  json.extract! history, :id, :title, :content
  json.url history_url(history, format: :json)
end
