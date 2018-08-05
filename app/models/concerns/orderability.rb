module Orderability
  extend ActiveSupport::Concern

  included do
    scope :order_by_id, (-> { order(id: :desc) })
  end
end
