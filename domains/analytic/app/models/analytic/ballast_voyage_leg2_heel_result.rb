module Analytic
  class BallastVoyageLeg2HeelResult < HeelResult
    has_one :edq_result, class_name: EdqResult.name, foreign_key: :ballast_voyage_leg2_id, dependent: :nullify, touch: true
  end
end
