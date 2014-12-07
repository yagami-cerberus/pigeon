require 'singleton'

module UserAuth
  extend ActiveSupport::Concern
  
  included do
    helper_method :claims, :login?
    
    class_attribute :_acl_allow_guest
    self._acl_allow_guest = self._acl_allow_guest.nil? ? Set.new : self._acl_allow_guest.dup
  end

  module ClassMethods
    def allow_guest(*actions)
      actions.each {|a| self._acl_allow_guest.add a }
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
      session[:__claims] = RegularClaims.to_claim_session user
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
  
  private
  def create_claims
    if session[:__claims]
      user_data = session[:__claims].symbolize_keys
      return RegularClaims.new(user_data)
    else
      return GuestClaims.instance
    end
  end
end

class RegularClaims
  def self.to_claim_session user
    {:id => user.id, :identify => user.username,
      :name => user.name, :email => user.email, :acl => user.grouped_permissions}
  end
  
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

  def permit?(scope, *args)
    permit!(scope, *args)
  rescue AccessDenyError
    false
  end

  def permit!(scope, *args)
    if scope == :system
      unless @params[:acl]["system"].include?(args[0])
        raise AccessDenyError.new "Denied: :settings, #{args[0].inspect}"
      end
    elsif scope == :issue
      if issue_status_id_for("issue.view").count == 0
        raise AccessDenyError.new "Denied: :issue"
      end
    elsif scope == :inspection
      if issue_status_id_for("inspection.view").count == 0
        raise AccessDenyError.new "Denied: :issue"
      end
    elsif scope.is_a?Issue
      l = @params[:acl]["issues"][scope.issue_status_id.to_s]
      unless l && l['actions'].include?(args[0])
        raise AccessDenyError.new "Denied: issue\##{scope.id}, #{args[0]}"
      end
    else
      raise AccessDenyError.new "Unknow scope: #{scope.inspect}"
    end
    true
  end
  
  def can_update_issue_status_to(issue)
    l = @params[:acl]["issues"][issue.issue_status_id.to_s]
    return l ? l['to'] : []
  end

  def issue_status_id_for(action)
    @params[:acl]["issues"]
      .select { |id, actions| actions["actions"].include?action }
      .map { |id, _| id.to_i }
  end

  def model
    User.find(@params[:id])
  end
end

class GuestClaims
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
  
  def permit?(*args)
    false
  end
  
  def permit!(*args)
    raise AccessDenyError.new "I'm a guest"
  end

  def can_update_issue_status_to(issue)
    []
  end
  
  def issue_status_id_for(action)
    []
  end
  
  def guest?
    true
  end
  
  def model
  end
end

class AccessDenyError < RuntimeError
end
