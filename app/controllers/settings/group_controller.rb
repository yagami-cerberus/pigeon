class Settings::GroupController < ApplicationController
  before_action -> {
    claims.permit! :system, 'admin.manage_users'
  }

  def index
    @new_group = Group.new
    @groups = Group.all
  end
  
  def new
    @group = Group.new
  end
  
  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to settings_group_index_path
    else
      render :template => 'settings/group/new'
    end
  end
  
  def edit
    @group = Group.find(params[:id])
  end
  
  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(group_params)
      redirect_to params[:refer] || settings_group_index_path
    else
      render :template => 'settings/group/edit'
    end
  end
  
  def destroy
    Group.find(params[:id]).destroy
    redirect_to (request.referer || settings_group_index_path)
  end
  
  private
  def group_params
    params.require(:group).permit([:name, {:system_flags_items => []}])
  end
end
