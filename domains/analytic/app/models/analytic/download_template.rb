module Analytic
  class DownloadTemplate
    include Mongoid::Document
    include Mongoid::Timestamps
    extend Enumerize

    enumerize :shared, in: [:local, :public]

    field :imo_no, type: Integer
    field :name, type: String
    field :channels, type: Object
    field :author_id, type: Integer
    field :bk_channels, type: Object
    field :latest_updated_by_id, type: Integer

    validates_presence_of :author_id, :imo_no, :name, :shared

    scope :readable, -> (author_id) {
      return [] if author_id.blank?
      any_of({shared: :local, author_id: author_id}, { shared: :public })
    }

    def ownable?(author_id)
      self.author_id == author_id
    end

    def public?
      self.shared == 'public'
    end
  end
end

