require 'watir'
require 'nokogiri'

class CsAcademy < ApplicationRecord
  self.pluralize_table_names = false

  BASE_URL = 'https://csacademy.com'

  def self.update_contests
    browser = Watir::Browser.new :chrome, headless: true, binary: ENV['GOOGLE_CHROME_BIN']

    # request csacademy contests page
    browser.goto 'https://csacademy.com/contests'
    contests = Nokogiri::HTML(browser.element(css: 'table').html).css('tbody tr')

    # delete old contests from database
    delete_all

    # add contests
    contests.each do |contest|
      tds = contest.css('td')

      start_time = tds[1].text.split(',').first
      start_time += ' '
      start_time += tds[1].text.split('(').last.tr(')', '')
      
      create(name: tds[0].css('a').to_s.insert(9, BASE_URL),
             start_time: start_time,
             duration: tds[2].text)
    end

    browser.close
  end
end
