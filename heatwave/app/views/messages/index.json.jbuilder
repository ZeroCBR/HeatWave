json.array!(@messages) do |message|
  json.extract! message, :id, :index
  json.url message_url(message, format: :json)
end
