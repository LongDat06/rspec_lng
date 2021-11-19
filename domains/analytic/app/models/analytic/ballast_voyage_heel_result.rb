module Analytic
  class BallastVoyageHeelResult < HeelResult
    has_one :edq_result, class_name: EdqResult.name, foreign_key: :ballast_voyage_id, dependent: :nullify, touch: true
  end
end
