class PagesController < ApplicationController  
  def home
    @sites = SITES.map do |site|
      [
        site.first,
        site.second,
        site.second.camelize.constantize.where(status: 'BEFORE'),
        site.second.camelize.constantize.where(status: 'CODING'),
        LastUpdate.where(site: site.second).first.date
      ]
    end
  end
  
  def about
    @join = Join.new
  end
end
