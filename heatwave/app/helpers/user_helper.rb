## Empty UserHelper
module UserHelper; end

## Standardises custom form labels for User forms.
class UserFormBuilder < ActionView::Helpers::FormBuilder
  def label(attribute, options = {})
    case attribute
    when :f_name
      'Given Name'
    when :l_name
      'Family Name'
    when :admin_access
      'Administrator?'
    else
      super
    end
  end
end
