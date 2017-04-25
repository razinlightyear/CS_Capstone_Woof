module WeightsHelper
  def weight_range_dropdown(weight_ranges)
    weight_ranges.map{|w| ["#{w.start_weight} lbs - #{w.end_weight.nil? ? "up" : "#{w.end_weight} lbs"}",w.id]}
  end
end
