class Profile < ActiveRecord::Base
  validates :identify, presence: true,
    format: { with: /\A[a-z0-9_\-\.]+\z/i, on: :create}, length: { in: 3..30 },
    uniqueness: {:case_sensitive => false, :scope => [:identify]}
  
  def sex
    case self.sex_flag
    when 'm'
      :male
    when 'f'
      :female
    end
  end
  
  def sex=(value)
    value = value.to_sym
    case value
    when :male
      self.sex_flag = 'm'
    when :female
      self.sex_flag = 'f'
    else
      self.sex_flag = nil
    end
  end
end
