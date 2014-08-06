namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "admin",
                         email: "ut@infopolis.com.ua",
                         password: "herbalife",
                         password_confirmation: "herbalife",
                         admin: true)
  end
end