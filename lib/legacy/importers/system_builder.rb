# frozen_string_literal: true

module Legacy
  module Importers
    class SystemBuilder
      def self.system
        {
          name: 'Arenah',
          initiative: {
            formula: '',
            order: ''
          },
          life: {
             base_attribute_group: 'Status',
             base_attribute_name: 'Vida'
          },
          sheet: {
            pages: [
              { number: 1, number_of_columns: 2, show_header: true, show_footer: false },
              { number: 2, number_of_columns: 1, show_header: true, show_footer: false },
            ],
            attributes_groups: [
              {
                name: 'Dados',
                page: 1,
                order: 1,
                type: 'character_card',
                position: 'header',
                source_type: 'fixed',
                show_on_posts: false,
                instructions: '',
                character_attributes: [
                  { 'name': 'Nome', 'description': 'Nome do personagem', 'order': 1 },
                  { 'name': 'XP', 'description': '', 'order': 2 },
                  { 'name': 'Classe', 'description': '', 'order': 3 },
                  { 'name': 'Dinheiro', 'description': '', 'order': 4 },
                  { 'name': 'Nível', 'description': '', 'order': 5 },
                  { 'name': 'Raça', 'description': '', 'order': 6 }
                ]
              },
              {
                name: 'Atributos',
                page: 1,
                order: 1,
                type: 'name_value',
                position: 'column_1',
                source_type: 'fixed',
                show_on_posts: true,
                order_on_posts: 1,
                show_title_on_posts: true,
                instructions: '',
                character_attributes: []
              },
              {
                name: 'História',
                page: 2,
                order: 1,
                position: 'header',
                type: 'rich_text',
                source_type: 'open',
                instructions: 'A história do <b>personagem</b> é importante para torná-lo mais real, para que se possa compreendê-lo de forma mais profunda e detalhada. Escreva o que achar relevante sobre o passado, o presente e as ambições para o futuro, bem como a aparência, suas principais habilidades e os eventos pelos quais se tornou famoso.',
                character_attributes: []
              },
              {
                name: 'Status',
                page: 1,
                order: 1,
                position: 'column_2',
                type: 'mixed',
                show_on_posts: true,
                order_on_posts: 2,
                show_title_on_posts: true,
                source_type: 'fixed',
                character_attributes: [
                  { name: 'Vida', order: 1, type: 'bar', master_only: true, description: 'Indica quantos pontos de vida o personagem possui.' },
                  { name: 'Magia', order: 2, type: 'bar', master_only: true, description: 'Poder arcano do personagem. Quanto mais pontos de magia, mais magias diferentes o mago pode invocar e mais fortes elas serão.' }
                ]
              },
            ]
          },
          dice_roll_rules: [],
          dice_result_rules: []
        }
      end
    end
  end
end
