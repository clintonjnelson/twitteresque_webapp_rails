# This code populates the database with fake users
# Users have random names but number-incremented emails starting at 1

namespace :db do
  desc "Fill in database with sample data"
  task populate: :environment do
    make_admin_user
    make_users
    make_microposts
    make_relationships
  end
end

def make_admin_user
  # Make primary user & toggle the admin attribute to ON
  admin = User.create!(name: "Example User",  #! raises error instead of "false" for easier debugging
               email: "example@railstutorial.org",
               password: "foobar",
               password_confirmation: "foobar")
  admin.toggle!(:admin)
end

def make_users
  # Make rest of random users
  99.times do |n|
    name = Faker::Name.name
    email = "example#{n+1}@railstutorial.org"
    password = "password"
    User.create!(name: name,  #! raises error instead of "false" for easier debugging
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_microposts
  users = User.all(limit: 3)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content)}
  end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followed_users.each { |followed| user.follow!(followed) }
  followers = users[3..40]
  followers.each { |follower| follower.follow!(user) }
end




