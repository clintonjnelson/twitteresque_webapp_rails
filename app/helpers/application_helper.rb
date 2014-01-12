module ApplicationHelper

  # Helper method to provide proper page <title> name or default name.
  def full_title(page_title)
    base_title = "Ruby on Rails Tutorial Sample App"
    page_title.empty? ? base_title : "#{base_title} | #{page_title}"
  end

end
