FactoryBot.define do
    factory :analytic_voyage_summaries  do
        imo {9874466}
        voyage_no {"020"}
        voyage_leg {"L"}
        manual_port_arrival {"TORONTO"}
        manual_port_dept {"CAT LAI"}
        manual_atd_lt {"2021-10-30"}
        manual_ata_lt {"2021-10-30"}
        manual_ata_time_zone {"Helsinki"}
        manual_atd_time_zone {"Helsinki"}
        manual_distance {1000}
    end
end