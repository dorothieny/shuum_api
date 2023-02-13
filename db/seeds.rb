# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Soundcard.destroy_all
puts "Destroyed everything you touch"
soundcards = Soundcard.create([
    {
    name: "Дождь на Китай-городе",
    description: "Я бежала утром в aic но шел очень сильный дождь и так громко барабанил по крышам, что я даже заслушалась",
    audiofile: File.open(Rails.root.join('public', 'sounds', 'kitai.m4a')),
    image: File.open(Rails.root.join('public', 'images', 'kitai.jpeg')),
    location: "",
    user_id: 1,
    },

    {
    name: "Попугаи в Рио",
    description: "Так необычно что это просто дикие попугаи, прилетевшие на пляж",
    audiofile: File.open(Rails.root.join('public', 'sounds', 'parrots.m4a')),
    image: File.open(Rails.root.join('public', 'sounds', 'parrots.m4a')),
    location: "",
    user_id: 1,
    },
    ])

    # likes = Like.create([
        
    #     {soundcard_id: 1, user_id: 1}
        
    # ])



    