module Ais
  module VesselForms
    class Base
      include ActiveModel::Validations
      include Virtus.model

      attribute :id, String
      attribute :imo, Integer
      attribute :engine_type, String
      attribute :ecdis_email, String
      attribute :target, Boolean
    end
  end
end
