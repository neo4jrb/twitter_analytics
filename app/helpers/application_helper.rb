module ApplicationHelper
  def action_and_controller_javascript_include_tag
    capture do
      concat javascript_include_tag controller_name if Rails.root.join("app/assets/javascripts/#{controller_name}.js.coffee").exist?
      concat javascript_include_tag "#{controller_name}/#{action_name}" if Rails.root.join("app/assets/javascripts/#{controller_name}/#{action_name}.js.coffee").exist?
    end
  end

  def action_and_controller_stylesheet_link_tag
    capture do
      concat stylesheet_link_tag controller_name if Rails.root.join("app/assets/stylesheets/#{controller_name}.css.scss").exist?
      concat stylesheet_link_tag "#{controller_name}/#{action_name}" if Rails.root.join("app/assets/stylesheets/#{controller_name}/#{action_name}.css.scss").exist?
    end
  end
end
