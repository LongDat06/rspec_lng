Rails.application.config.to_prepare do
  Wisper.clear if Rails.env.development? || Rails.env.test?
  Wisper.subscribe(Ais::LastDepartureListener.new)
  Wisper.subscribe(Ais::ImportAisSimListener.new)
  Wisper.subscribe(Ais::ImportVesselDestinationSpasListener.new)
  Wisper.subscribe(Analytic::VesselAssociatedDeletionListener.new)
  Wisper.subscribe(Analytic::VesselCreationListener.new)
end
