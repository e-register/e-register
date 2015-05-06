# Edit the ActiveRecord class to randomize the id when the model is created
class ::ActiveRecord::Base
  before_create :randomize_id

  def randomize_id
    begin
      self.id = rand(1_000_000)
    end while self.class.where(id: self.id).exists?
  end
end
