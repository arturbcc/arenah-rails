module Legacy
  class ImporterParams
    EXPECTED_PARAMS = [
      :users,
      :characters,
      :games
    ].freeze

    def path_params
      @path_params ||= begin
        path_params = {}

        EXPECTED_PARAMS.each do |key|
          path_params[key] = ENV.fetch("#{key.to_s.upcase}_PATH", "#{key.to_s.downcase}.csv")
        end

        path_params
      end
    end

    def to_usage_params
      EXPECTED_PARAMS.map do |param|
        "#{param.to_s.upcase}_PATH='path/to/#{param.to_s.downcase}.csv'"
      end.join(' ')
    end

    def valid_path?
      EXPECTED_PARAMS.reduce(true) do |status, param|
        status &= File.file?(path_params[param])
      end
    end
  end
end
