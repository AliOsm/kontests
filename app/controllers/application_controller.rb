class ApplicationController < ActionController::Base
  before_action :initialize_suggest

  def initialize_suggest
    @suggest = Suggest.new
  end
end
