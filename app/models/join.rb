class Join < ApplicationRecord
  include Orderability

  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :how

  validates_length_of :name, maximum: 255
  validates_length_of :email, maximum: 255
  validates_length_of :how, maximum: 5000

  validates_email_format_of :email
end
