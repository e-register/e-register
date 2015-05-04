class Score < ActiveRecord::Base
  has_many :evaluations, dependent: :restrict_with_error

  default_scope ->{ order(:value) }

  validates_presence_of :as_string

  # Return the Score with the nearest value to the specified one
  def self.from_value(value)
    # The lowest score greater or equal to value
    upper = unscoped.where('value >= ?', value).where(is_counted: true).order('value asc').first
    # The biggest score lower or equal to value
    lower = unscoped.where('value <= ?', value).where(is_counted: true).order('value desc').first

    return nil if upper.nil? && lower.nil?
    return upper if lower.nil?
    return lower if upper.nil?

    # Select the nearest to the value
    if (upper.value - value) < (value - lower.value)
      upper
    else
      lower
    end
  end


  def score_class
    if !is_counted
      'info'
    elsif value >= APP_CONFIG['evaluations']['sufficient_value']
      'success'
    else
      'danger'
    end
  end
end
