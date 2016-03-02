# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

3.times do
  User.create(
      email: Faker::Internet.email,
      password: Faker::Internet.password
  )
end

User.all.each do |user|
  5.times do
    media = user.media.create name: Faker::Lorem.word, user_id: user.id

    3.times do
      media.pictures.create image: File.open(Rails.root.join('spec', 'factories', 'files', 'cat.jpg')), medium_id: media.id
      media.links.create url: Faker::Internet.url, medium_id: media.id
    end
  end
end
