# frozen_string_literal: true

# TODO: Consider transforming this into a presenter. It could decide if the view
# will show title, show edit button and so on. Check the partial _group_title
# to see more possibilities
module AttributesGroupHelper
  def class_for_points_counter(group)
    points = group.points || 0
    counter_class = ''
    if group.used_points < points
      counter_class = 'available-points'
    elsif group.used_points > points
      counter_class = 'exceeded-points'
    end

    counter_class
  end
end
