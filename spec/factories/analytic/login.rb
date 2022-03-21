FactoryBot.define do
    factory :user, class: Identity::User  do
        id {'60'}
        email {'dat.huynh@dounets.com'}
        password {'123456'}
        fullname {'Cris'}
        role {'0'}
    end
end

  