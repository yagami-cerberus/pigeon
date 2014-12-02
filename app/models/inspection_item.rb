class InspectionItem < ActiveRecord::Base
  has_many :inspection_atoms, -> { order :order_index }, :dependent => :destroy
  
  validates :title, presence: true, length: { in: 1..100 }
  validates :sample_type, presence: true, length: {in: 1..30 }
  
  default_scope { order('code ASC, title ASC') }
  
  def self.group_names
    unscoped.group(:group_name).order('group_name ASC').pluck(:group_name)
  end
end
