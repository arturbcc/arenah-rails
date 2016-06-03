# frozen_string_literal: true

module Legacy
  class ImporterParams
    EXPECTED_PARAMS = [
      :users,
      :characters,
      :user_partners,
      :games,
      :topics,
      :posts
    ].freeze

    def path_params
      @path_params ||= begin
        path_params = {}

        EXPECTED_PARAMS.each do |key|
          path_params[key] = "misc/csvs/#{key.to_s.downcase}.csv"
        end

        path_params
      end
    end

    def valid_path?
      EXPECTED_PARAMS.reduce(true) do |status, param|
        status &= File.file?(path_params[param])
      end
    end
  end
end
