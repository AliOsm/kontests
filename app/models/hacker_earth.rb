require 'watir'
require 'nokogiri'

class HackerEarth < ApplicationRecord
  self.pluralize_table_names = false

  def self.update_contests
    opts = {
      headless: true
    }

    if chrome_bin = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
      opts.merge!(options: {binary: chrome_bin})
    end

    browser = Watir::Browser.new :chrome, opts

    # request hackerearth contests page
    browser.goto 'https://www.hackerearth.com/challenges/'
    browser.wait_until { browser.element(css: '.ongoing').exists? }
    html = Nokogiri::HTML(browser.html)

    # delete old contests from database
    delete_all

    # add contests
    cards = html.css('.ongoing').css('.challenge-card-modern')
    cards.each do |card|
      end_time = nil
      unless card.css('.challenge-desc').text.include? 'Sign In'
        days = (card.css('#days-1').text.strip + card.css('#days-0').text.strip).to_i
        hours =  (card.css('#hours-1').text.strip + card.css('#hours-0').text.strip).to_i
        minutes = (card.css('#minutes-1').text.strip + card.css('#minutes-0').text.strip).to_i
        seconds = (card.css('#seconds-1').text.strip + card.css('#seconds-0').text.strip).to_i
        end_time = Time.now.utc + days.days + hours.hours + minutes.minutes + seconds.seconds
      end

      unless end_time.nil?
        company = card.css('.company-details').text.strip

        create(company: company.blank? ? '-' : company,
               name: '<a href="https://www.hackerearth.com%s" target="_blank">%s</a>' % [card.css('.challenge-card-wrapper').first['href'], card.css('.challenge-name').text.strip],
               type_: card.css('.challenge-type').text.strip,
               start_time: '-',
               end_time: generate_tad_url(end_time),
               duration: '-',
               in_24_hours: 'Yes',
               status: 'CODING')
      end
    end

    # add contests
    cards = html.css('.upcoming').css('.challenge-card-modern')
    cards.each do |card|
      company = card.css('.company-details').text.strip
      start_time = Time.parse(card.css('.challenge-desc .date').text).utc

      create(company: company.blank? ? '-' : company,
             name: '<a href="https://www.hackerearth.com%s" target="_blank">%s</a>' % [card.css('.challenge-card-wrapper').first['href'], card.css('.challenge-name').text.strip],
             type_: card.css('.challenge-type').text.strip,
             start_time: generate_tad_url(start_time),
             end_time: '-',
             duration: '-',
             in_24_hours: in_24_hours?(start_time),
             status: 'BEFORE')
    end

    browser.close

    update_last_update 'hacker_earth'
  end
end
