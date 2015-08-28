json.array!(@users) do |user|
  json.extract! user, :id, :username, :f_name, :l_name, :password, :adminAccess, :gender, :address, :phone, :age, :email, :suscribed, :birthday, :postcode
  json.url user_url(user, format: :json)
end
