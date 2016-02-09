module RPG
  class Page
    include EmbeddedModel

    attribute :number, :integer
    attribute :number_of_columns, :integer
    attribute :show_header, :boolean

    def show_header?
      show_header
    end
  end
end
