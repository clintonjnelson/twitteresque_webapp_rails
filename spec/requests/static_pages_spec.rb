require 'spec_helper'

describe "StaticPages" do
  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { page.should      have_selector(  'h1',    text: 'Sample App'         )}
    it { page.should      have_selector(  'title', text: full_title('')       )}
    it { page.should_not  have_selector(  'title', text: full_title('| Home') )}
  end

  describe "Help page" do
    before { visit help_path }

    it { page.should      have_selector(  'h1',    text: 'Help'               )}
    it { page.should      have_selector(  'title', text: full_title('Help')   )}
  end

  describe "About page" do
    before { visit about_path }

    it { page.should      have_selector(  'h1',    text: 'About'                )}
    it { page.should      have_selector(  'title', text: full_title('About Us') )}
  end

  describe "Contact page" do
    before { visit contact_path }

    it { page.should      have_selector(  'h1',    text: 'Contact'            )}
    it { page.should      have_selector(  'title', text: full_title('Contact'))}
  end
end

#Formerly looked like:
#describe "StaticPages" do

#let(:base_title) {"Ruby on Rails Tutorial Sample App"}

#describe "Home page" do
# before { visit root_path }

# it "should have the h1 'Sample App'" do
#   page.should have_selector('h1', text: 'Sample App')
# end
#     # Use have_selector to check for a HTML tag element with given content
# it "should have the right title" do
#   page.should have_selector('title', text: "#{base_title}")
#   # Note that a substring like :text => ' | Home' would also be effective
# end

# it "should not have a custom page title" do
#   page.should_not have_selector('title', text: "| Home")
# end

