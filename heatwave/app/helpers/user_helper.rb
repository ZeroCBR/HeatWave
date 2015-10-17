## Empty UserHelper
module UserHelper; end

## Standardises custom form labels for User forms.
class UserFormBuilder < ActionView::Helpers::FormBuilder
  def label(attribute, options = {})
    case attribute
    when :f_name
      super attribute, 'Given Name', options
    when :l_name
      super attribute, 'Family Name', options
    when :admin_access
      super attribute, 'Administrator?', options
    else
      return super
    end
  end
end
