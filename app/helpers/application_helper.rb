module ApplicationHelper
  PAGEJS_ALIASES = { 'create' => 'new', 'update' => 'edit' }.freeze

  # Public: The data value for PageJS.
  #
  # It uses the same convetion for Rails routes controller#action as identifier
  # for javascript page initialization. But accepts options to overwrite them.
  #
  # Check page.js and application.js for further info.
  #
  # Examples
  #
  #  # When the `PagesController#show` action is rendering a view.
  #  pagejs # => 'pages/show'
  #
  #  # When the `PagesController#create` action is rendering the `new` view
  #  #  when the validation fails.
  #  pagejs # => 'pages/new'
  #
  # Returns a String.
  def pagejs
    controller = params[:controller]
    view = PAGEJS_ALIASES[params[:action]] || params[:action]
    "#{controller}##{view}"
  end

  def icon(icon)
    content_tag :i, '', class: "fa fa-#{icon}"
  end
end
