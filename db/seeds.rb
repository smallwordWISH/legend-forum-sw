# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Category.destroy_all

category_list = [ 
  {name: "technology" },
  {name: "culture" },
  {name: "entrepreneurship" },
  {name: "creativity" },
  {name: "self" },
  {name: "politics" },
  {name: "media" }, 
  {name: "photography" },
  {name: "design" },
  {name: "music" }, 
  {name: "film" },
  {name: "work out" }
]

category_list.each do |category|
  Category.create( name: category[:name])
end

puts "have created #{Category.count} category data"


User.destroy_all

User.create(name:"admin", email: "admin@example.com", password: "12345678", role: "admin")
puts "Default admin created! ( email: admin@example.com, password: 12345678 )"