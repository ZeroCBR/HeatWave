json.array!(@messages) do |message|
  json.extract! message, :id, :user, :content, :send_time :message_type, :sent_to,
  json.url message_url(message, format: :json)
end
