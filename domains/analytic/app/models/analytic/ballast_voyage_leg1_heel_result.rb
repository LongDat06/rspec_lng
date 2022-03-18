module Analytic
  class BallastVoyageLeg1HeelResult < HeelResult
    has_one :edq_result, class_name: EdqResult.name, foreign_key: :ballast_voyage_leg1_id, dependent: :nullify, touch: true
  end
end
