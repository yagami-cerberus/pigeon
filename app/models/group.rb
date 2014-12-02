class Group < ActiveRecord::Base
  include BitFlags
  
  has_and_belongs_to_many :users, :join_table => :user_groups
  has_many :issue_status_permissions
  
  default_scope { order(:name) }
  
  validates :name, presence: true
  
  bit_flags :system_flags, {
    0 => :manage_users,
    1 => :manage_products
  }
  
  PERMISSIONS = {
    :manage_users => 'admin.manage_users',
    :manage_products => 'admin.manage_products'
  }
  
  def permissions
    roles = Set.new
    PERMISSIONS.each do |symbol, role|
      if self.send(symbol)
        splited_role = role.split('.')
        splited_role.length.times do |i|
          roles.add splited_role[0..i].join('.')
        end
      end
    end
    roles
  end
end
