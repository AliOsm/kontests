require 'nokogiri'

class AtCoder < ApplicationRecord
  self.pluralize_table_names = false
  self.primary_key = :code

  def to_param
    code.parametarize   
  end

  def self.update_contests
    # request atcoder contests page
    tables = Nokogiri::HTML(open('https://atcoder.jp/contest', 'User-Agent' => USER_AGENT).read).css('.table-default')
    tables.pop

    # delete old contests from database
    delete_all

    tables.each_with_index do |table, i|
      contests = table.css('tbody > tr')
      
      # add contests
      contests.each do |contest|
        tds = contest.css('> td')
        
        start_time = Time.zone.parse("#{tds[0].css('a').first.text} JST").in_time_zone('UTC')
        a = tds[1].css('a').first
        url = a['href']
        duration = tds[2].text
  
        tds = contest.css('table td')
  
        create(code: url.split('.').first.split('/').last,
               name: add_target_attr(a.to_s),
               start_time: generate_tad_url(start_time),
               duration: duration,
               participate: tds[1].text,
               rated: tds[3].text,
               in_24_hours: in_24_hours?(start_time),
               status: i == 0 ? 'CODING' : 'BEFORE')
      end
    end
    
    update_last_update 'at_coder'
  end
end
