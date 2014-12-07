class IssueStatus < ActiveRecord::Base
  validates :mode, inclusion: { in: %w(processing finished) }
  
  scope :processing, -> { where.not :mode => 'finished' }
  scope :finished, -> { where :mode => 'finished' }
  
  has_many :issue_status_permissions
  accepts_nested_attributes_for :issue_status_permissions, :allow_destroy => false
  
  def prepare_group_permissions
    Group.where.not(:id => self.issue_status_permissions.pluck(:group_id)).each do |g|
      self.issue_status_permissions.build :group => g
    end
  end
end
