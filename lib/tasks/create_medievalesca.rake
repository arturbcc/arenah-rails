# frozen_string_literal: true

namespace :game do
  desc 'Create game room Medievalesca'
  task medievalesca: :environment do
    require 'open-uri'
    require 'colorize'

    PATH = '/public/games/'.freeze
    puts "Creating #{"Medievalesca".green}"

    puts 'Fetching users...'
    marco = User.find_by(email: 'soueu.marco@hotmail.com')
    lucas = User.find_by(email: 'lucasontable@gmail.com')

    puts 'Creating characters...'
    master_marco = Character.create!(user: marco, name: 'Marco', avatar: 'marco.jpg', character_type: 2, sheet: '{}')
    master_lucas = Character.create!(user: lucas, name: 'Lucas', avatar: 'lucas.jpg', character_type: 2, sheet: '{}')

    puts 'Creating game room...'
    medievalesca = Game.create!(
      name: 'Medievalesca',
      # short_description: 'Era uma vez uma história que foi contada de novo e de novo e de novo. Trocavam os nomes, a ordem dos eventos, a cor dos monstros, mas no fundo era a mesma narrativa. Era uma história que todos já estavam cansados. Nela havia um mundo com criaturas fantásticas, reinos, guerreiros, magos, ladinos, e um vilão que queria dominá-lo. Numa tentativa de mantê-la ainda viva e suportável, criaram complexas tramas políticas, mitologias emaranhadas e personagens cada vez mais profundos. O antigo mundo de guerreiros e magos foi deixado para trás, como a sombra de um antigo mal que assola uma terra em paz. E como o antigo mal que assola uma terra em paz, velhas histórias sempre voltam a ser contadas.',
      short_description: 'Era uma vez uma história que foi contada de novo e de novo e de novo. Trocavam os nomes, a ordem dos eventos, a cor dos monstros, mas no fundo era a mesma narrativa. Era uma história que todos já estavam cansados. Nela havia um mundo com criaturas fantásticas, reinos, guerreiros, magos, ladinos, e um...',
      description: 'Medievalesca é um rpg de fantasia medieval, como tantos outros. Mas é um rpg de fantasia medieval cheio de referências à cultura pop, com inspirações em FF8 e Hogwarts, e uma pitada de crítica social.\n\nNossa história começa em Twinhills Kingdom, antigamente o reino mais pobre de Medievalesca. Com a ascenção da nova rainha, uma ex-plebeia por quem o príncipe se encantou, novas medidas foram tomadas para que o reino voltasse a crescer com prosperidade. E as duas medidas que mais nos interessam são a criação da Escola de Aventureiros de Orman e o programa Aventuras Sem Fronteiras.\n\nA Escola, situada na cidade de Orman, surgiu com o intuito de dar um futuro para tantos órfãos que habitavam Twinhills. Já no seu quarto ano de funcionamento,  a instituição tem cerca de cem moradores, entre alunos e colaboradores, e cresce cada vez mais. Como o objetivo da Escola é formar aventureiros, todos os órfãos que moram nela e passam sua juventude aprendendo e treinando têm a obrigação de servirem o reino, através do Aventuras Sem Fronteiras. Em outras palavras, eles são financiados para explorar o mundo, resolver alguns problemas típicos de aventureiros e trazer suas descobertas de volta para o reino. \n\nAcompanhando a vida escolar dos personagens, entre uma missão e outra pelo mundo de Medievalesca, o RPG não mostrará somente a evolução de cada personagem, mas acompanhará também a evolução da Escola. Ou seja, após cada missão concluída, os personagens trarão novidades para a E.A.O. e para Twinhills Kingdom, o que proporcionará modificações no cenário.\n\n',
      banner: 'medievalesca.jpg',
      character: master_lucas,
      subtitle: '',
      system: '{}')

    puts 'Subscribing users...'
    master_marco.update(game: medievalesca)
    master_lucas.update(game: medievalesca)

    create_folders(medievalesca)
    import_assets(medievalesca)
    create_topic_groups(medievalesca)
    puts 'Done'.green
  end

  def import_assets(medievalesca)
    banner_url = 'http://www.rpg.arenah.com.br/resources/banners/rooms/medievalesca.jpg'
    current_path = File.join(Rails.root, PATH, medievalesca.slug, 'images', 'banners')
    download(current_path, banner_url, 'medievalesca', 'banner')

    current_path = File.join(Rails.root, PATH, medievalesca.slug, 'images', 'avatars')
    avatar_url = 'http://www.rpg.arenah.com.br/resources/avatar/1-3d9b586a-5398-437b-83e4-27e0a88713ce.jpg'
    download(current_path, avatar_url, 'marco')

    avatar_url = 'http://www.rpg.arenah.com.br/resources/avatar/c036a5b4-3809-4395-9ed5-96e2338a4f40.JPG'
    download(current_path, avatar_url, 'lucas')
  end

  def download(path, url, name, type = 'avatar')
    puts "Downloading #{name.titleize} #{type}"

    begin
      open("#{path}/#{name.downcase}.jpg", 'wb') do |file|
        file << open(url).read
      end
    rescue => e
      puts "Could not download #{type} for #{name.titleize}".red
      puts e
    end
  end

  def create_folders(game)
    path = File.join(Rails.root, PATH, game.slug)

    unless File.directory?(path)
      Dir.mkdir(path)
      Dir.mkdir(File.join(path, 'css'))
      Dir.mkdir(File.join(path, 'images'))
      Dir.mkdir(File.join(path, 'images', 'avatars'))
      Dir.mkdir(File.join(path, 'images', 'banners'))
      Dir.mkdir(File.join(path, 'images', 'equipments'))
    end

    path = File.join(Rails.root, PATH, game.slug, 'css', 'custom.css')
    FileUtils.touch(path)
  end

  def create_topic_groups(game)
    TopicGroup.create!(game: game, name: 'Geral', position: 1)
    puts "Group 'Geral' created at position 1"
    group = TopicGroup.create!(game: game, name: 'Jogo', position: 2)
    puts "Group 'Jogo' created at position 2"
  end
end
