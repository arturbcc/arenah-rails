module RPG
  class Page
    include EmbeddedModel

    attr_accessor :number, :number_of_columns, :show_header

    def show_header?
      !!show_header
    end
  end
end
