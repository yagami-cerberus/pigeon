require 'filters/user_filter'

class Settings::UserController < ApplicationController
  before_action -> {
    claims.permit! :system, 'admin.manage_users'
  }

  PASSWORD_FIELDS = [:password, :password_confirmation]
  UPDATE_USER_FIELDS = [:firstname, :lastname, :email, {:group_ids => []}]
  CREATE_USER_FIELDS = [:username] + PASSWORD_FIELDS + UPDATE_USER_FIELDS
  
  def index
    @filter = Pigeon::Filters::UserFilter.new(params[:filter])
    @current_page, @page_size, @users = @filter.paginate(@filter.filter(User).order('username'), params[:p])
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params.require(:user).permit(CREATE_USER_FIELDS))
    
    if @user.save
      redirect_to user_path(@user)
    else
      render :template => 'settings/user/new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
  
    if @user.update_attributes(params.require(:user).permit(UPDATE_USER_FIELDS))
      redirect_to (params[:refer].presence || user_path(@user))
    else
      render :template => 'settings/user/edit'
    end
  end
  
  def show
    @user = User.find(params[:id])
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to (request.referer || user_index)
  end

  def edit_password
    @user = User.find(params[:id])
    render :partial => 'edit_password_modal'
  end

  def reset_password
    @user = User.find(params[:id])
    if params[:remove]
      @success = @user.update_attribute('hashed_password', nil)
      redirect_to request.referer
    else
      @success = @user.update_attributes(params.require(:user).permit(PASSWORD_FIELDS))
      render :partial => 'edit_password_modal'
    end
  end

  def add_apikey
    u = User.find(params[:id])
    @apikey = ApiKey.create u
    render :partial => 'add_api_key_modal'
  end

  def delete_apikey
    User.find(params[:id]).api_keys.find_by_key(params[:key]).destroy
    redirect_to request.referer
  end

  def set_disabled
    @user = User.find(params[:id])
    case params[:flag]
    when 't'
      @user.disabled = true
    when 'f'
      @user.disabled = false
    end
    @user.save
    redirect_to (request.referer || settings_user_path(@user))
  end
end
