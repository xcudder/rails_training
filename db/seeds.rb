# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

companies = Company.create([
    { name: 'EA Games' }, { name: 'Bethesda' }, { name: 'Livraria Cultura'}, { name: 'Saraiva' }
])

categories = Category.create([
    { name: 'Adventure' }, { name: 'Romance' }, { name: 'Sci-Fi'}, { name: 'Horror' }
])

platforms = Platform.create([
    { name: 'PS4' }, { name: 'XBOX' }, { name: 'PC' }
])

#EA Games
companies[0].games.create([
    {name: 'Mass Effect', description: 'A nice space adventure', price: 120.00, platform: platforms[1]},
    {name: 'FIFA 06', description: 'The same ol\' sports game', price: 15.00, platform: platforms[2]}
])

#Bethesda Games
companies[1].games.create([
    {name: 'Skyrim', description: 'A nice medieval adventure', price: 140.00, platform: platforms[0]},
    {name: 'Fallout', description: 'The same ol\' post-apocalyptic shooter', price: 110.00, platform: platforms[2]}
])

#Livraria Cultura Books
companies[2].books.create([
   {
        name: 'Watchmen',
        description: 'Realistic heroes being deconstructed',
        price: 10.00,
        author: 'Alan Moore',
        editor: 'DC Comics',
        category: categories[0]
    },
    {
        name: 'The Fountainhead',
        description: 'Objectivist libertarian propaganda',
        price: 10.00,
        author: 'F. Scott Fitzgerald',
        editor: 'Dover Publications',
        category: categories[1]
    }
])

#Saraiva Books
companies[3].books.create([
    {
        name: 'The Great Gatsby',
        description: 'Waking up from the american dream',
        price: 10.00,
        author: 'F. Scott Fitzgerald',
        editor: 'Record',
        category: categories[1]
    },
    {
        name: 'The Beautiful and Damned',
        description: 'The familiar story of a character eroded by idleness',
        price: 10.00,
        author: 'F. Scott Fitzgerald',
        editor: 'Dover Publications',
        category: categories[1]
    }
])

#Employees
employees = Employee.create [{name:'Jack'},{name:'James'},{name:'John'}]

project_tags = Tag.create [{name:'Large Project', tag_type_id: 1},{name:'Medium Project', tag_type_id: 1},{name:'Small Project', tag_type_id: 1}]
country_tags = Tag.create [{name:'Brazil', tag_type_id: 2},{name:'Spain', tag_type_id: 2},{name:'Japan', tag_type_id: 2}]
role_tags    = Tag.create [{name:'Developer', tag_type_id: 3},{name:'Manager', tag_type_id: 3},{name:'Designer', tag_type_id: 3}]

employees[0].tags << project_tags[0]
employees[0].tags << project_tags[0]
employees[0].tags << project_tags[0]

employees[1].tags << project_tags[1]
employees[1].tags << project_tags[1]
employees[1].tags << project_tags[1]

employees[2].tags << project_tags[2]
employees[2].tags << project_tags[2]
employees[2].tags << project_tags[2]
