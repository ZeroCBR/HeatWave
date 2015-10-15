## A service for creating the initial admin account.
class CreateAdminService
  def call(melbourne)
    params = { email: Rails.application.secrets.admin_email,
               admin_access: true, location: melbourne,
               f_name: 'Heatwave', l_name: 'Administrator',
               gender: 'An enigma', age: 99, message_type: 'email' }
    User.find_or_create_by!(params) do |u|
      u.password = Rails.application.secrets.admin_password
      u.password_confirmation = Rails.application.secrets.admin_password
    end
  end
end
