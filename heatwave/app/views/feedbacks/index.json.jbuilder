json.array!(@feedbacks) do |feedback|
  json.extract! feedback, :id, :title, :content, :comment, :responded
  json.url feedback_url(feedback, format: :json)
end
