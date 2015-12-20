module ApplicationHelper
  def icon(icon)
    content_tag :i, '', class: "fa fa-#{icon}"
  end
end
