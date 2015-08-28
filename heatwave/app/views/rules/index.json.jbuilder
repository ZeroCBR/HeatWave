json.array!(@rules) do |rule|
  json.extract! rule, :id, :name, :annotation
  json.url rule_url(rule, format: :json)
end
