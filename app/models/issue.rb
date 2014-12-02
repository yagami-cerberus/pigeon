class Issue < ActiveRecord::Base
  belongs_to :issue_status
  
  belongs_to :profile
  accepts_nested_attributes_for :profile
  validates :profile, presence: true
  
  has_many :issue_bundles, :dependent => :destroy
  accepts_nested_attributes_for :issue_bundles, :allow_destroy => true
  validates :issue_bundles, presence: true, length: {minimum: 1}
  
  has_many :inspection_bundles, -> { uniq }, :through => :issue_items
  
  has_many :samples
  accepts_nested_attributes_for :samples, :allow_destroy => true

  belongs_to :created_by, :class_name => 'User'
  
  # scope :viewable, -> (claim) { where :id => claim }
  scope :processing, -> { where.not :issue_statuses => {:mode => 'finished'} }
  scope :finished, -> { where :issue_statuses => {:mode => 'finished'} }
end
