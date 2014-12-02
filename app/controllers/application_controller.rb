class ApplicationController < ActionController::Base
  include UserAuth
  
  # TODO:
  # rescue_from ActionController::ParameterMissing, :render_error_page
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :validate_access_control
  protect_from_forgery with: :exception
  layout "application"
  
  def validate_access_control
    unless allow_guest?
      if claims.guest?
        redirect_to login_path
      else
        if not accessable?
          render 'layouts/access_deny', :status => 401
        end
      end
    end
  end
end
