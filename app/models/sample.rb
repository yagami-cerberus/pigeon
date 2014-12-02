class Sample < ActiveRecord::Base
  belongs_to :issue
  
  validates :no, presence: true,
    format: { with: /\A[a-z0-9_\-]+\z/i, on: :create}, length: { in: 3..30 }
  
  validates :sample_type, presence: true, length: { in: 1..30 }
  validates :quantity, presence: true, numericality: {greather_than_or_equal_to: 0, only_integer: true}
end
