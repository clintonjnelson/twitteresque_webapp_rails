require 'spec_helper'

describe "StaticPages" do
  subject { page }

  shared_examples_for "all static pages" do
    it { should           have_selector(  'h1',    text: heading               )}
    it { should           have_selector(  'title', text: full_title(page_title))}
  end

  it "should have the right links on the layout" do
    visit root_path
      # Clicks the link on the root page
      click_link 'About'
      page.should have_selector 'title', text: full_title('About Us')

      click_link 'Help'
      page.should have_selector 'title', text: full_title('Help')

      click_link 'Contact'
      page.should have_selector 'title', text: full_title('Contact')

      click_link 'Home'
      page.should have_selector 'title', text: full_title('')

      click_link 'sample app'
      page.should have_selector 'title', text: full_title('')

      click_link 'Sign Up Now!'
      page.should have_selector 'title', text: full_title('Sign Up')
  end

  ############################ Pages to Check #####################
  describe "Home page" do
    before { visit root_path }
    let(:heading) {'Sample App'}
    let(:page_title) {''}

    # Trigger the typcial checks method based on our let settings
    it_should_behave_like 'all static pages'
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading) {'Help'}
    let(:page_title) {'Help'}

    it_should_behave_like 'all static pages'
  end

  describe "About page" do
    before { visit about_path }
    let(:heading) {'About'}
    let(:page_title) {'About Us'}

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading) {'Contact'}
    let(:page_title) {'Contact Us'}

    it_should_behave_like 'all static pages'
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


## Then looked like this before second refactor:
# describe "Help page" do
#     before { visit help_path }

#     it { page.should      have_selector(  'h1',    text: 'Help'               )}
#     it { page.should      have_selector(  'title', text: full_title('Help')   )}
#   end

#   describe "About page" do
#     before { visit about_path }

#     it { page.should      have_selector(  'h1',    text: 'About'                )}
#     it { page.should      have_selector(  'title', text: full_title('About Us') )}
#   end

#   describe "Contact page" do
#     before { visit contact_path }

#     it { page.should      have_selector(  'h1',    text: 'Contact'            )}
#     it { page.should      have_selector(  'title', text: full_title('Contact'))}
#   end
# end
