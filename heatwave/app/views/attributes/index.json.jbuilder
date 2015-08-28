json.array!(@attributes) do |attribute|
  json.extract! attribute, :id, :name, :annotation
  json.url attribute_url(attribute, format: :json)
end
