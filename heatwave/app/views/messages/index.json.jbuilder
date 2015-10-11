json.array!(@messages) do |message|
  json.extract!(@message,
                :id,
                :user,
                :content,
                :send_time,
                :message_type,
                :sent_to,
                :created_at,
                :updated_at)
  json.url message_url(message, format: :json)
end
