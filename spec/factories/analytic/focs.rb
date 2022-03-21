FactoryBot.define do
    factory :foc, class: Analytic::Foc  do
        imo {9874454}
        speed {100}
        laden {49}
        ballast {48.9}
        updated_by_id {60}
    end
end