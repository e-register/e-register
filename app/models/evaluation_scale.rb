class EvaluationScale < ActiveRecord::Base
  serialize :checkpoints, JSON

  def compute_score(items)
    # trim the value to [0, 1]
    return nil if items < 0.0 || items > 1.0

    # insert the limit values (0% and 100%)
    points = checkpoints['checkpoints']
    points.unshift( { 'percentage' => 0.0, 'value' => Score.minimum('value') } )
    points.push( { 'percentage' => 1.0, 'value' => Score.maximum('value') } )

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
end
