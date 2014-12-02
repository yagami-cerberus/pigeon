class ProfilesController < ApplicationController
  def search
    if params[:q].present?
      records = Profile.where('identify LIKE :kw', :kw => "#{params[:q]}%")
      datas = records.map do |b|
        {:id => b.id, :text => "[#{b.identify}] #{b.firstname} #{b.surname}"}
      end
      
      render :json => datas
    else
      render :json => []
    end
  end
  
  def selector_tmpl
    if params[:id].present?
      profile = Profile.find(params[:id])
    else
      profile = Profile.new
    end
    
    render :partial => 'profile/profile_tmpl', :locals => {profile: profile, form_prefix: params[:form_prefix] || ''}
  end
end
