module Analytic
  class EdqResult < ApplicationRecord

    belongs_to :vessel, class_name: :Vessel, foreign_key: :imo, primary_key: :imo

    belongs_to :laden_voyage, class_name: LadenVoyageHeelResult.name,
                              foreign_key: :laden_voyage_id, optional: true,
                              dependent: :destroy,
                              autosave: true
    belongs_to :ballast_voyage, class_name: BallastVoyageHeelResult.name,
                                foreign_key: :ballast_voyage_id, optional: true,
                                dependent: :destroy,
                                autosave: true
    belongs_to :author, class_name: ::Shared::User.name,
                        foreign_key: :author_id
    belongs_to :updated_by, class_name: ::Shared::User.name,
                            foreign_key: :updated_by_id

    scope :join_laden_voyage, -> {
      joins(<<-SQL)
        LEFT JOIN analytic_heel_results AS laden_voyage
        ON laden_voyage.id = analytic_edq_results.laden_voyage_id
      SQL
    }

    scope :join_ballast_voyage, -> {
      joins(<<-SQL)
        LEFT JOIN analytic_heel_results AS ballast_voyage
        ON ballast_voyage.id = analytic_edq_results.ballast_voyage_id
      SQL
    }

    scope :join_user_updated_by, -> {
      joins(<<-SQL)
        LEFT JOIN users AS updated_by
        ON updated_by.id = analytic_edq_results.updated_by_id
      SQL
    }

    scope :in_laden_voyage_port_dept, -> (port) {
      join_laden_voyage.where(laden_voyage: { port_dept: port })
    }

    scope :in_laden_voyage_port_arrival, -> (port) {
      join_laden_voyage.where(laden_voyage: { port_arrival: port })
    }

    scope :in_ballast_voyage_port_dept, -> (port) {
      join_ballast_voyage.where(ballast_voyage: { port_dept: port })
    }

    scope :in_ballast_voyage_port_arrival, -> (port) {
      join_ballast_voyage.where(ballast_voyage: { port_arrival: port })
    }


    def ownable?(user_id)
      self.author_id == user_id
    end

    def vessel_name
      read_attribute("vessel_name") || vessel&.name
    end

    def updated_by_name
      read_attribute("updated_by_name") || updated_by&.fullname
    end


  end
end
