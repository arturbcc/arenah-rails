# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


user1 = User.create!(email: "test@arenah.com.br", name: "John Doe", nickname: "John Doe", password: "X03MO1qnZdYdgyfeuILPmQ==")
user2 = User.create!(email: "test@arenah.com.br", name: "Jane Roe", nickname: "Jane", password: "X03MO1qnZdYdgyfeuILPmQ==")
game = Game.create!(name: 'Resident Evil', status: 1)
character1 = Character.create!(name: 'Jill', game: game, user: user1)
character2 = Character.create!(name: 'Valentine', game: game, user: user1)
topic_group = TopicGroup.create!(game: game, name: 'O Jogo')
topic = Topic.create!(topic_group: topic_group, title: 'Capítulo 1', game: game)
Post.create!(character: character1, topic: topic, message: 'lorem ipsum dolor sit amet')
Post.create!(character: character2, topic: topic, message: 'segundo post')
Post.create!(character: character1, topic: topic, message: 'terceiro post')
