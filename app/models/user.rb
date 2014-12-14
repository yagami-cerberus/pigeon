class User < ActiveRecord::Base
  include UserExtention
  include BitFlags
  
  has_and_belongs_to_many :groups, :join_table => :user_groups do
    def merged_group
      select("bit_or(system_flags) as system_flags")[0]
    end

    def permissions
      merged_group.permissions.to_a
    end
  end

  has_many :issue_status_permissions, :through => :groups do
    def merged_issue_status_permissions
      group(:issue_status_id).select(
              "issue_status_id",
              "bit_or(permission_flags) as permission_flags",
              "uniq(sort(array_agg_mult(issue_status_ids))) as issue_status_ids")
    end

    def permissions
      Hash[merged_issue_status_permissions.map do |p|
        [
          p.issue_status_id,
          {:actions => p.permissions, :to => p.issue_status_ids}
        ]
      end]
    end
  end

  has_many :api_keys

  validates :username, presence: true,
    format: { with: /\A[a-z0-9_\-\.]+\z/i, on: :create }, length: { in: 3..30 },
    uniqueness: {:case_sensitive => false, :scope => [:username]}

  validates :firstname, presence: true, length: { maximum: 100 }
  validates :lastname, presence: true, length: { maximum: 100 }
  
  validates :email, format: /\A^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]+\z/i,
    length: { maximum: 100 }, allow_blank: true
  
  scope :disabled?, Proc.new { |disabled| 
    express = disabled ? 'flags & ? > 0' : 'flags & ? = 0'
    where(express, 1)
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
    {
      'system' => self.groups.permissions,
      'issues' => self.issue_status_permissions.permissions
    }
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
