class PortableController < ApplicationController
  allow_guest :login

  def dashboard
  end
  
  def login
    if request.method == 'POST'
      @error = login_macro User, params[:username], params[:password] do |u|
        process_login u
        redirect_to params[:to] || root_path
        return
      end
    end
    render :layout => 'anonymous'
  end
  
  def logout
    process_logout
    redirect_to params[:to] || root_path
  end
  
  def my_profile
  end
  
  def passwd
  end
  
  def change_passwd
    @error = validate_passwd do |user, new_password|
      user.password = new_password
      user.save!
      redirect_to params[:to] || root_path
    end
    render 'passwd' if @error
  end
  
  private
  def login_macro(account_scope, identify, password)
    u = account_scope.find_by_login(identify)
    
    unless u.nil?
      if u.challenge_password(password)
        if u.disabled
          return 'security.account_disabled'
        else
          yield u
        end
      end
    end
    return 'security.login_failed'
  end
  
  def validate_passwd &black
    user = claims.model
  
    if user.challenge_password(params[:old_password])
      password = params[:new_password]
      return 'security.password_not_match' if password != params[:confirm_new_password]
      return 'security.weak_password' if password.nil? or password.length < 6
      yield user, password
      
      return nil
    else
      return 'security.bad_password'
    end
  end
end
