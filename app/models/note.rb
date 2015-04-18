class Note < ActiveRecord::Base
  belongs_to :teacher, class_name: User
  belongs_to :notable, polymorphic: true

  default_scope { where(visible: true) }
end
