require 'nokogiri'

class A2oj < ApplicationRecord
  self.pluralize_table_names = false
  self.primary_key = :code

  BASE_URL = 'https://a2oj.com/'

  def to_param
    code.parametarize   
  end

  def self.update_contests
    # request a2oj contests page
    tables = Nokogiri::HTML(open('https://a2oj.com/', 'User-Agent' => USER_AGENT).read).css('.tablesorter')
    tables.pop

    # delete old contests from database
    delete_all

    tables.each_with_index do |table, i|
      contests = table.css('tbody tr')
      
      # add contests
      contests.each do |contest|
        tds = contest.css('td')
  
        code_name = tds[1].text.partition('-')
        code = code_name.first.strip
        name = code_name.last.strip
  
        owner = add_target_attr(tds[2].css('a').first.to_s.insert(9, BASE_URL))
  
        start_time = Time.parse(tds[3].css('a').first.text)

        before_start = '-'
        # special case for future contests
        before_start = tds[3].css('b').first.text if i == 1

        before_end = '-'
        # special case for running contests
        before_end = tds[4].css('b').text if i == 0
  
        duration = tds[4].text
        # special case for running contests
        duration.remove!(tds[4].css('b').text) if i == 0
  
        registrants = add_target_attr(tds[5].css('a').first.to_s.insert(9, BASE_URL))
  
        type = tds[6].text
  
        if type.eql?('Public')
          registration = add_target_attr(tds[7].css('a').first.to_s.insert(9, BASE_URL))
        else
          registration = 'By invitation only'
        end
  
        create(code: code.to_i,
               name: name,
               owner: owner,
               start_time: generate_tad_url(start_time),
               before_start: before_start,
               before_end: before_end,
               duration: duration,
               registrants: registrants,
               type_: type,
               registration: registration,
               in_24_hours: in_24_hours?(start_time),
               status: i == 0 ? 'CODING' : 'BEFORE')
      end
    end
  end
end
