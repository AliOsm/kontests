require 'watir'
require 'nokogiri'

class CsAcademy < ApplicationRecord
  self.pluralize_table_names = false

  BASE_URL = 'https://csacademy.com'

  def self.update_contests
    opts = {
      headless: true
    }

    if chrome_bin = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
      opts.merge!(options: {binary: chrome_bin})
    end

    browser = Watir::Browser.new :chrome, opts

    # request csacademy contests page
    browser.goto 'https://csacademy.com/contests'
    browser.wait_until { browser.element(css: 'table').exists? }
    contests = Nokogiri::HTML(browser.element(css: 'table').html).css('tbody tr')

    # delete old contests from database
    delete_all

    # add contests
    contests.each do |contest|
      tds = contest.css('td')

      start_time = tds[1].text.split(',').first
      start_time += ' '
      start_time += tds[1].text.split('(').last.tr(' UTC)', '')
      start_time = Time.parse(start_time)
      
      create(name: add_target_attr(tds[0].css('a').to_s.insert(9, BASE_URL)),
             start_time: generate_tad_url(start_time),
             duration: tds[2].text,
             in_24_hours: in_24_hours?(start_time))
    end

    browser.close
  end
end
