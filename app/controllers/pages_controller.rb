class PagesController < ApplicationController  
  def home
    @sites = SITES.map do |site|
      [site.first, site.second, site.second.camelize.constantize.all]
    end
  end
end
