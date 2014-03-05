# This is a new /support/utilities.rb folder we created
# Rspec knows to look inside this new folder & include its files

include ApplicationHelper

# def full_title(page_title)
#   base_title = "Ruby on Rails Tutorial Sample App"
#   page_title.empty? ? base_title : "#{base_title} | #{page_title}"
# end

def sign_in(user)
  visit signin_path
  fill_in "Email",                with: user.email
  fill_in "Password",             with: user.password
  click_button "Sign In"

  # Sign in when not using capybara as well
  cookies[:remember_token] = user.remember_token
end
