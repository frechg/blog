# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = User.create(user_name: "Ex Person", email: "person@example.com", password: "testingpass")

5.times do |i|
  Article.create(user: user, title: "Article #{i}", body: "An article.", status: "public")
end
