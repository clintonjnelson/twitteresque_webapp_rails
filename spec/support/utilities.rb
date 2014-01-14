# This is a new /support/utilities.rb folder we created
# Rspec knows to look inside this new folder & include its files

def full_title(page_title)
  base_title = "Ruby on Rails Tutorial Sample App"
  page_title.empty? ? base_title : "#{base_title} | #{page_title}"
end
