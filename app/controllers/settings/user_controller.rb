require 'filters/user_filter'

class Settings::UserController < ApplicationController
  before_action -> {
    claims.permit! :system, 'admin.manage_users'
  }

  PASSWORD_FIELDS = [:password, :password_confirmation]
  UPDATE_USER_FIELDS = [:name, :email, {:group_ids => []}]
  CREATE_USER_FIELDS = [:username] + PASSWORD_FIELDS + UPDATE_USER_FIELDS
  
  def index
    @filter = Pigeon::Filters::UserFilter.new(params[:filter])
    @current_page, @page_size, @users = @filter.paginate(@filter.filter(User), params[:p])
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
  end
  
  def reset_password
    @user = User.find(params[:id])
    if @user.update_attributes(params.require(:user).permit(PASSWORD_FIELDS))
      redirect_to (params[:refer].presence || settings_user_path(@user))
    else
      render :template => 'settings/user/edit_password'
    end
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
