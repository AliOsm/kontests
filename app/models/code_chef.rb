require 'nokogiri'

class CodeChef < ApplicationRecord
  self.pluralize_table_names = false
  self.primary_key = :code

  def to_param
    code.parametarize   
  end

  def self.update_contests
    # request codechef contests page
    contests = Nokogiri::HTML(open('https://www.codechef.com/contests', 'User-Agent' => 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0').read).css('.dataTable')[1].css('tbody > tr')

    # delete old contests from database
    delete_all

    # add contests
    contests.each do |contest|
      tds = contest.css('> td')
  
      create(code: tds[0].text,
             name: tds[1].text,
             start_time: tds[2].text,
             end_time: tds[3].text)
    end
  end
end
