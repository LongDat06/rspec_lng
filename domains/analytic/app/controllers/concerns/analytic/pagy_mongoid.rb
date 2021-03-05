module Analytic
  module PagyMongoid
    def pagy_mongoid(collection, vars={})
      pagy = Pagy.new(count: collection.count, page: params[:page], **vars)
      return pagy, collection.skip(pagy.offset).limit(pagy.items)
    end
  end
end
