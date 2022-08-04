# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'json'
require 'open-uri'

if ENV['minimal'] == 'yes'
  Game.destroy_all

  url = "https://api.rawg.io/api/games?key=#{ENV[RAWG_API]}"
  doc = URI.parse(url).open.read
  response = JSON.parse(doc)
  games = response['results']
  games.take(20).each do |game|
    genres = []
    game['genres'].each { |hash| genres << hash['name'] }
    platforms = []
    game['platforms'].each { |hash| platforms << hash['platform']['name'] }
    this = Game.new(title: game['name'], genre: genres.join(" "), developer: "Hamish Liu", console: platforms.join(" "), price: 3.5, release_date: game['released'], image_url: game['background_image'])
    this.save
    p this.title
  end
end

puts 'Makin that seedy boi'

seedyboi = User.new(email: 'seedy@seed.com', password: '123456', name: 'Seedy Seed Boi')
seedyboi.save!

p seedyboi.name

List.create(name: 'completed', user_id: seedyboi.id)
List.create(name: 'currently playing', user_id: seedyboi.id)
List.create(name: 'want to play', user_id: seedyboi.id)
