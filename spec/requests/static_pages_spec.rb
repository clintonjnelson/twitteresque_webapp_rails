require 'spec_helper'

describe "StaticPages" do

  let(:base_title) {"Ruby on Rails Tutorial Sample App"}

  describe "Home page" do
    it "should have the h1 'Sample App'" do
      visit '/static_pages/home'
      page.should have_selector('h1', :text => 'Sample App')
    end

    # Use have_selector to check for a HTML tag element with given content
    it "should have the right title" do
      visit '/static_pages/home'
        page.should have_selector('title',
          :text => "#{base_title} | Home")
          # Note that a substring like :text => ' | Home' would also be effective
    end

    it "should not have the a custom page title" do
      visit '/static_pages/home'
        page.should_not have_selector('title', :text => '| Home')
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
          :text => "#{base_title} | Help")
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
          :text => "#{base_title} | About")
          # Note that a substring like :text => ' | Home' would also be effective
    end
  end

  describe "Contact page" do
    it "should have the h1 'Contact'" do
      visit '/static_pages/contact'
      page.should have_selector('h1', :text => 'Contact')
    end

    # Use have_selector to check for a HTML tag element with given content
    it "should have the right title" do
      visit '/static_pages/contact'
        page.should have_selector('title',
          :text => "#{base_title} | Contact Us")
          # Note that a substring like :text => ' | Home' would also be effective
    end
  end

end
