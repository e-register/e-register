class EvaluationScale < ActiveRecord::Base
  has_many :evaluations, dependent: :destroy

  serialize :checkpoints, JSON

  def compute_score(items)
    # trim the value to [0, 1]
    return nil if items < 0.0 || items > 1.0

    points = prepare_points

    points.each_with_index do |point, i|
      # search for the lowest point grater or equal to items
      if point['percentage'] >= items
        # if the point is not the first do the interpolation with the previous point
        if i > 0
          prev = points[i-1]
          value = compute_value(prev, point, items)
        else
          value = point['value']
        end
        return Score.from_value(value)
      end
    end
    # The control cannot reach this point
  end

  private

  # Compute the linear interpolation between the lower and the higher point
  # Returns:
  #   The interpolated value according to the target percentage
  def compute_value(low, hi, target)
    low['value'] +
        (hi['value']-low['value']) * (target-low['percentage']) / (hi['percentage']-low['percentage'])
  end

  # Add the lower and upper bound to the checkpoints (0% and 100% if missing)
  # Returns:
  #   An Array of Hash. Each hash has 2 keys: percentage and value
  def prepare_points
    points = checkpoints['checkpoints'] || []
    if points.length == 0 || points.first['percentage'] != 0.0
      points.unshift( { 'percentage' => 0.0, 'value' => Score.minimum('value') } )
    end
    if points.last['percentage'] != 1.0
      points.push( { 'percentage' => 1.0, 'value' => Score.maximum('value') } )
    end
    points
  end
end
