class IssueValue < ActiveRecord::Base
  belongs_to :inspection_atom
  belongs_to :issue_bundle
  belongs_to :editor, :class_name => 'User'

  default_scope { includes :inspection_atom }

  delegate :inspection_item, :to => :inspection_atom
  delegate :title, :to => :inspection_atom
  delegate :group_name, :to => :inspection_atom
  delegate :code, :to => :inspection_atom
  delegate :sample_type, :to => :inspection_atom
  delegate :type_handler, :to => :inspection_atom

  def update_value(payload, editor)
    case type_handler.data_type
    when :text
      if self.data != payload["text"]
        self.data, self.editor = payload["text"], editor
        self.save!
        return true
      else
        return false
      end
    else
      raise "Bad Inspection Data Type: #{type_handler.data_type}"
    end
  end

  def value_error?
    inspection_atom.value_error? self.data
  end
end
