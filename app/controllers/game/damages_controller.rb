# frozen_string_literal: true

class Game::DamagesController < Game::BaseController
  before_action :authenticate_user!

  def show
    @ids = characters_ids
    @selected_characters = selected_characters
    @topic = current_topic

    render :show, layout: false
  end

  def create
    if @identity.game_master? && current_game.system.life_defined?
      damage = params[:damage].to_i

      victims_ids.each do |id|
        if character = @game.characters.find_by(id: id) && life = character.life_attribute
          life.points -= damage
          character.save!
        end
      end
    end

    render :nothing
  end

  private

  def characters_ids
    @characters_ids ||= map_ids(:group_characters)
  end

  def victims_ids
    @victims_ids ||= map_ids(:character_ids)
  end

  def map_ids(param_name)
    ids = params.fetch(param_name, '')
    ids.split(',').map(&:to_i)
  end

  def selected_characters
    current_game.characters.select { |character| @ids.include?(character.id) }
  end

  def current_topic
    @current_topic ||= Topic.find_by(
      slug: params[:topic],
      game_id: current_game.id)
  end
end
