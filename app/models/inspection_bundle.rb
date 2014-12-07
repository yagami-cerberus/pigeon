class InspectionBundle < ActiveRecord::Base
  has_many :issue_bundles
  has_many :issues, :through => :issue_bundles

  validates :title, presence: true
  validates :group_name, presence: true
  validates :code, presence: true
  
  def self.group_names
    unscoped.group(:group_name).order('group_name ASC').pluck(:group_name)
  end
  
  def inspection_items
    InspectionItem.where :id => self.item_ids
  end
end
