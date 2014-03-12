# This code populates the database with fake users
# Users have random names but number-incremented emails starting at 1

namespace :db do
  desc "Fill in database with sample data"
  task populate: :environment do
    # Make primary user & toggle the admin attribute to ON
    admin = User.create!(name: "Example User",  #! raises error instead of "false" for easier debugging
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar")
    admin.toggle!(:admin)

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

    users = User.all(limit: 3)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content)}
    end
  end
end
