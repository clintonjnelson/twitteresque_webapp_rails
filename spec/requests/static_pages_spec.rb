require 'spec_helper'

describe "StaticPages" do

  describe "Home page" do
    it "should have the h1 'Sample App'" do
      visit '/static_pages/home'
      page.should have_selector('h1', :text => 'Sample App')
    end

    # Use have_selector to check for a HTML tag element with given content
    it "should have the right title" do
      visit '/static_pages/home'
        page.should have_selector('title',
          :text => "Ruby on Rails Tutorial Sample App | Home")
          # Note that a substring like :text => ' | Home' would also be effective
    end
  end

  describe "Help page" do
    it "should have the h1 'Help'" do
      visit '/static_pages/help'
      page.should have_selector('h1', :text => 'Help')
    end

    # Use have_selector to check for a HTML tag element with given content
    it "should have the right title" do
      visit '/static_pages/help'
        page.should have_selector('title',
          :text => "Ruby on Rails Tutorial Sample App | Help")
          # Note that a substring like :text => ' | Help' would also be effective
    end
  end

  describe "About page" do
    it "should have the h1 'About'" do
      visit '/static_pages/about'
      page.should have_selector('h1', :text => 'About')
    end

    # Use have_selector to check for a HTML tag element with given content
    it "should have the right title" do
      visit '/static_pages/about'
        page.should have_selector('title',
          :text => "Ruby on Rails Tutorial Sample App | About")
          # Note that a substring like :text => ' | Home' would also be effective
    end
  end

end
