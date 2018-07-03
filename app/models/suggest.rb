class Suggest < ApplicationRecord
  validates_presence_of :site
  validates :site, url: true
  validates_length_of :site, maximum: 255
  validates_length_of :email, maximum: 255
  validates_email_format_of :email, allow_blank: true
  validates_length_of :message, maximum: 5000
end
