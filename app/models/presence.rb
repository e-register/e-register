class Presence < ActiveRecord::Base
  belongs_to :teacher, class_name: User
  belongs_to :student
  belongs_to :presence_type
  belongs_to :justification
end
