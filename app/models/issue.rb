class Issue < ActiveRecord::Base
  belongs_to :issue_status

  belongs_to :profile
  accepts_nested_attributes_for :profile
  validates :profile, presence: true

  has_many :issue_bundles, :dependent => :destroy
  accepts_nested_attributes_for :issue_bundles, :allow_destroy => true
  validates :issue_bundles, length: { minimum: 1 }

  has_many :samples
  accepts_nested_attributes_for :samples, :allow_destroy => true

  belongs_to :created_by, :class_name => 'User'

  scope :viewable, -> (claims) { where(:issue_status_id => claims.issue_status_id_for('issue.view')) }
  scope :processing, -> { where.not :issue_statuses => {:mode => 'finished'} }
  scope :finished, -> { where :issue_statuses => {:mode => 'finished'} }
  scope :status_equal, -> (val) { where(:issue_status_id => val) }

  def can_update_status_to(claim)
    ids = claim.can_update_issue_status_to(self)
    IssueStatus.where(:id => ids)
  end
end
