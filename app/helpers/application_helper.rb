module ApplicationHelper

  # Defined in here because it is for ALL pages, not just static_pages.
  # Helper method to provide proper page <title> name or default name.
  def full_title(page_title)
    base_title = "StayInTouch"
    page_title.empty? ? base_title : "#{base_title} | #{page_title}"
  end
end
