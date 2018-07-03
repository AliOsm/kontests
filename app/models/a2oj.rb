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
    contests = Nokogiri::HTML(open('https://a2oj.com/', 'User-Agent' => USER_AGENT).read).css('.tablesorter')[1].css('tbody tr')

    # delete old contests from database
    delete_all

    # add contests
    contests.each do |contest|
      tds = contest.css('td')

      code_name = tds[1].text.partition('-')
      code = code_name.first.strip
      name = code_name.last.strip

      owner = add_target_attr(tds[2].css('a').first.to_s.insert(9, BASE_URL))

      start_time = Time.parse(tds[3].css('a').first.text)
      before_start = tds[3].css('b').first.text

      duration = tds[4].text

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
             start_time: generate_tad_url(start_time, start_time.strftime('%d/%m/%Y %H:%M:%S')),
             before_start: before_start,
             duration: duration,
             registrants: registrants,
             type_: type,
             registration: registration)
    end
  end
end
