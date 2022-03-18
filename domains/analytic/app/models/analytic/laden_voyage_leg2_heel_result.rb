module Analytic
  class LadenVoyageLeg2HeelResult < HeelResult
    has_one :edq_result, class_name: EdqResult.name, foreign_key: :laden_voyage_leg2_id, dependent: :nullify, touch: true
  end
end
