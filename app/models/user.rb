class User < ActiveRecord::Base
  include UserExtention
  include BitFlags
  
  has_and_belongs_to_many :groups, :join_table => :user_groups
  
  validates :username, presence: true,
    format: { with: /\A[a-z0-9_\-\.]+\z/i, on: :create }, length: { in: 3..30 },
    uniqueness: {:case_sensitive => false, :scope => [:username]}

  validates :name, presence: true, length: { maximum: 100 }
  
  validates :email, format: /\A^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]+\z/i,
    length: { maximum: 100 }, allow_blank: true
  
  scope :disabled?, Proc.new { |disabled| 
    express = disabled ? 'flags & ? > 0' : 'flags & ? = 0'
    where(express, USER_FLAG_DISABLED)
  }
  
  bit_flags :flags, {
    0 => :disabled
  }
  
  def self.find_by_login(identify)
    where('lower("username") = ?', identify.downcase).first 
  end
  
  def process_login
    update_column(:lastlogin_at, DateTime.now.utc)
  end
  
  def grouped_permissions
    groups.unscope(:order).select("bit_or(system_flags) as system_flags")[0].permissions.to_a
  end
    
  def save(*args)
    User.transaction do
      if super(*args)
        raise ActiveRecord::Rollback if !self.valid? && self.errors[:username]
        return true
      end
    end
    return false
  end
end
