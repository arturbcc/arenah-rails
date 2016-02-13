module RPG
  class Page
    include EmbeddedModel

    attr_accessor :number, :number_of_columns, :show_header, :show_footer

    def show_header?
      !!show_header
    end

    def show_footer?
      !!show_footer
    end
  end
end
