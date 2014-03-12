require 'spec_helper'

describe "UserPages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { page.should      have_selector(  'h1',    text: 'Sign Up'            )}
    it { page.should      have_selector(  'title', text: 'Sign Up'            )}
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: 'Foo') }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: 'Bar') }
    before { visit user_path(user) }

    it { page.should      have_selector(  'h2',    text: user.name          )}
    it { page.should      have_selector(  'title', text: user.name          )}

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end
  end

  describe "edit page" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "content" do
      it { should      have_selector(  'h1',    text: "Update Your Profile"   )}
      it { should      have_selector(  'title', text: "Edit User"             )}
      it { should      have_link('Change', href: 'http://gravatar.com/emails' )}
    end

    describe "with Invalid information" do
      before { click_button "Save Changes" }

      it { should have_content('error') }
    end

    describe "with Valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) {"new@example.com"}

      before do
        fill_in "Name",               with: new_name
        fill_in "Email",              with: new_email
        fill_in "Password",           with: user.password
        fill_in "Confirm Password",   with: user.password
        click_button "Save Changes"
      end

        it { should have_selector('title', text: new_name )}
        it { should have_selector('div.alert.alert-success'   )}
        it { should have_link('Sign Out', href: signout_path  )}
        specify { user.reload.name.should   == new_name  }
        specify { user.reload.email.should  == new_email }

    end
  end


  describe "Signup Page" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: 'Sign Up') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",               with: "Example User"
        fill_in "Email",              with: "example@railstutorial.org"
        fill_in "Password",           with: "foobar"
        fill_in "Confirm Password",   with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) {User.find_by_email('example@railstutorial.org')}

        it { should have_selector('title',                    text: user.name )}
        it { should have_selector('div.alert.alert-success',  text: 'Welcome' )}
        it { should have_link('Sign Out')}
      end
    end
  end

  describe "index page" do
    # OLD CODE before pagination (pg398):
    # Populate a fake index page for testing
    # before do
    #   sign_in FactoryGirl.create(:user) # Creates & signs in base user
    #   FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
    #   FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
    #   visit users_path
    # end


    # Make & sign in a user
    let(:user) { FactoryGirl.create(:user) }

    #Create some users before testing. Delete them all after testing.
    before(:all)  { 30.times { FactoryGirl.create(:user) } }
    after(:all)   { User.delete_all }

    before(:each) do
      sign_in user
      visit users_path
    end

    # Checking for page content including list of users & their names
    it { should have_selector('title', text: "All Users") }
    it { should have_selector('h1',    text: "All Users") }

    describe "pagination" do
      it {should have_selector('div.pagination') }
      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end
      # OLD TESTS before pagination (pg 398)
      # it "should list each user" do
      # User.all.each do |user|
      #   page.should have_selector('li', text: user.name)
      # end

    describe "delete links" do
      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end
end









