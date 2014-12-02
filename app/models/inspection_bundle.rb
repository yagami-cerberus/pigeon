class InspectionBundle < ActiveRecord::Base
  has_many :issue_bundles
  has_many :issues, :through => :issue_bundles

  validates :title, presence: true
  validates :group_name, presence: true
  validates :code, presence: true
  
  # scope :join_issues, -> { joins 'LEFT JOIN "issue_inspection_bundles" ON "issue_inspection_bundles"."inspection_bundle_id" = "inspection_bundles"."id" LEFT JOIN "issues" ON "issues"."id" = "issue_inspection_bundles"."issue_id"' }
  
  def self.group_names
    unscoped.group(:group_name).order('group_name ASC').pluck(:group_name)
  end
  
  def inspection_items
    InspectionItem.where :id => self.item_ids
  end
end
