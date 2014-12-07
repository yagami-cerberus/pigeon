class ApplicationController < ActionController::Base
  include UserAuth
  
  # TODO:
  # rescue_from ActionController::ParameterMissing, :render_error_page
  rescue_from AccessDenyError, with: :render_access_deny_page
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :validate_access_control
  protect_from_forgery with: :exception
  layout "application"

  def validate_access_control
    if claims.guest? && !allow_guest?
      raise AccessDenyError.new "Access deny for anonymous"
    end
  end

  private
  def render_access_deny_page exception
    if request.xhr?
      error = claims.guest? ? 'LOGIN_REQUIRE' : 'ACCES_DENY'
      resp = {:status => false, :error => error}
      resp[:debug] = exception.inspect if Rails.configuration.consider_all_requests_local

      render :json => resp
    else
      if claims.guest?
        redirect_to login_path
      else
        @exception = exception if Rails.configuration.consider_all_requests_local

        render 'layouts/access_deny', :status => 403
      end
    end
  end
end
