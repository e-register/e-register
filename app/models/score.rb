class Score < ActiveRecord::Base
  has_many :evaluations, dependent: :restrict_with_error

  validates_presence_of :as_string

  # Return the Score with the nearest value to the specified one
  def self.from_value(value)
    # The lowest score greater or equal to value
    upper = where('value >= ?', value).where(is_counted: true).order('value asc').first
    # The biggest score lower or equal to value
    lower = where('value <= ?', value).where(is_counted: true).order('value desc').first

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
end
