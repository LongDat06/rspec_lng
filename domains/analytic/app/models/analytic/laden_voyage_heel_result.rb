module Analytic
  class LadenVoyageHeelResult < HeelResult
    has_one :edq_result, class_name: EdqResult.name, foreign_key: :laden_voyage_id, dependent: :nullify, touch: true
  end
end
