class PagesController < ApplicationController  
  def home
    @sites = SITES.map do |site|
      [
        site.first,
        site.second,
        site.second.camelize.constantize.where(status: 'BEFORE'),
        site.second.camelize.constantize.where(status: 'CODING')
      ]
    end
  end
  
  def about
  end
end
