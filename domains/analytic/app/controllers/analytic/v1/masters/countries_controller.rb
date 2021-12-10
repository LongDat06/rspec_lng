module Analytic
  module V1
    module Masters
      class CountriesController < BaseController

        def index
          data = TZInfo::Country.all.sort_by(&:name).map { |country| { name: country.name, code: country.code } }
          json_response(data)
        end

      end
    end
  end
end
