module Legacy
  class Report
    def initialize
      @masterless = []
      @playersless = []
    end

    def show
      header

      games.each do |game|
        puts '*'*15
        puts "#{game.name}".yellow
        show_masters(game)
        show_pcs(game)
        show_npcs(game)
        puts ''
      end

      footer
    end

    private

    def header
      puts ''
      puts 'Final Report'
      puts ''
    end

    def games
      Game.all.sort_by { |game| game.name }
    end

    def show_masters(game)
      @masterless << game if game.masters.count == 0
      game.masters.each { |master| puts "**[mestre] #{master.name}" }
    end

    def show_pcs(game)
      @playersless << game if game.pcs.count == 0
      game.pcs.each { |pc| puts "**[pc] #{pc.name}" }
    end

    def show_npcs(game)
      game.npcs.each { |npc| puts "**[npc] #{npc.name}" }
    end

    def footer
      puts ''
      puts 'Games without a master:'
      @masterless.each { |game| puts game.name.red }
      puts ''
      puts 'Games without players:'
      @playersless.each { |game| puts game.name.red }
      puts ''
    end
  end
end
