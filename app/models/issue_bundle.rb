class IssueBundle < ActiveRecord::Base
  belongs_to :issue
  belongs_to :inspection_bundle
  has_many :issue_values, -> { order_by "order" }, :dependent => :destroy
  has_many :inspection_atoms, :through => :issue_values
  
  scope :status, -> (status) { where :issues => {:issue_status_id => status} }
  
  after_save :update_inspection_values
  
  delegate :title, :to => :inspection_bundle
  delegate :code, :to => :inspection_bundle
  
  def inspection_item_ids= values
    write_attribute :inspection_item_ids, values.map { |i| i.to_i }
  end
  
  def inspection_items
    InspectionItem.where id: self.inspection_item_ids
  end
  
  def inspections
    issue_values.includes(:inspection_atom).group_by &:inspection_item
  end
  
  def update_inspection_values
    add_ids = InspectionAtom.
      includes(:inspection_item).
      where(:inspection_items => {:id => self.inspection_item_ids}).
      pluck :id

    self.issue_values.reload.each do |v|
      if add_ids.include? v.inspection_item_id
        add_ids.delete v.inspection_item_id
      else
        v.destroy
      end
    end

    add_ids.each do |id|
      self.issue_values.create :inspection_atom_id => id
    end
  end
end
