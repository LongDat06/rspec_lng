module Analytic
  module ChartServices
    class SchemaModel
      include Virtus.model

      attribute :chart_id, String
      attribute :chart_name, String
      attribute :axis_y, Array, default: []
      attribute :axis_x, String
    end
  end
end
