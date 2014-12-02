require 'singleton'

module UserAuth
  extend ActiveSupport::Concern
  
  included do
    helper_method :claims, :login?
    
    class_attribute :_acl_allow_guest
    class_attribute :_acl_default
    class_attribute :_acl
    
    self._acl_allow_guest = self._acl_allow_guest.nil? ? Set.new : self._acl_allow_guest.dup
    self._acl = self._acl.nil? ? {} : self._acl.dup
  end
  
  module ClassMethods
    def allow_guest(*actions)
      actions.each {|a| self._acl_allow_guest.add a }
    end
  
    def default_access_control(role)
      self._acl_default = role
    end
  
    def access_control(action, role)
      action = action.to_sym
      self._acl[action] = role
    end
  end
  
  protected
  def login?
    not claims.guest?
  end
  
  def claims
    @_claims ||= create_claims
  end
  
  def process_login(user)
    @_claims = nil
    user.process_login
    
    if user.instance_of?(User)
      session[:__claims] = {id: user.id, identify: user.username,
        name: user.name, email: user.email, roles: user.grouped_permissions}
    else
      raise "Unknow login instance"
    end
  end
  
  def process_logout
    session[:__claims] = nil
  end
  
  def allow_guest?
    return _acl_allow_guest.include?(action_name.to_sym)
  end
  
  def accessable?
    action = action_name.to_sym
    
    # Validate Role
    require_role = _acl.has_key?(action) ? _acl[action] : _acl_default
    if require_role
      return claims.has_role(require_role) if not require_role.nil?
    else
      return true
    end
  end
  
  private
  def create_claims
    if session[:__claims]
      user_data = session[:__claims].symbolize_keys
      return RegularUser.new(user_data)
    else
      return GuestUser.instance
    end
  end
end

class RegularUser
  def initialize(params = {})
    @params = params
  end
  
  def name
    @params[:name]
  end
  
  def identify
    @params[:identify]
  end
  
  def email
    @params[:email]
  end
  
  def superuser?
    false
  end
  
  def guest?
    false
  end
  
  def has_role(role)
    @params[:roles].include?(role)
  end
  
  def model
    User.find(@params[:id])
  end
end

class GuestUser
  include Singleton
  
  def name
    "Guest"
  end
  
  def identify
  end
  
  def email
  end
  
  def superuser?
    false
  end
  
  def has_role(role)
    false
  end
  
  def guest?
    true
  end
  
  def model
  end
end
