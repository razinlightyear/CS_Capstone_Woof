module ApplicationHelper
    def resource_name
        :user
    end

    def resource_class
        User
    end

    def resource
        @resource ||= User.new
    end

    def devise_mapping
        @devise_mapping ||= Devise.mappings[:user]
    end
    
    def bootstrap_class_for(flash_type)
      case flash_type
        when "success"
          "alert-success"   # Green
        when "error"
          "alert-danger"    # Red
        when "alert"
          "alert-warning"   # Yellow
        when "notice"
          "alert-info"      # Blue
        else
          flash_type.to_s
      end
    end
    
    def has_error?(record, attribute)
      record.errors[attribute].size > 0
    end
    
    def form_feedback(record, attribute)
      if has_error?(record, attribute)
        "<div class='form-control-feedback'>#{record.errors[attribute].join('</br>')}</div>"
      else
        ''
      end
    end
end
