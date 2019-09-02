require 'json'
require 'time'
require 'watir'
require 'open-uri'
require 'nokogiri'

module UpdateSitesService
  USER_AGENT = 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0'

  class << self
    include ActionView::Helpers::TextHelper
  
    def all
      # prepare contests
      all_contests = SITES[1..-1].map do |site|
        site.second.camelize.constantize.pluck(:name, :start_time, :duration, :in_24_hours, :status)
      end

      SITES[1..-1].each_with_index do |site, i|
        all_contests[i].each do |contest|
          contest << site.first
        end
      end

      all_contests.compact!
      all_contests = all_contests.flatten(1)

      all_contests.sort! do |a, b|
        if a.second.eql?('-')
          1
        elsif b.second.eql?('-')
          -1
        else
          Time.parse(a.second[(a.second.index('>') + 1)...a.second.index('<', 2)]) <=> Time.parse(b.second[(b.second.index('>') + 1)...b.second.index('<', 2)])
        end
      end

      # delete old contests from database
      All.delete_all

      # add contests
      all_contests.each do |contest|
        All.create(name: contest.first,
                   start_time: contest.second,
                   duration: contest.third,
                   in_24_hours: contest.fourth,
                   status: contest.fifth,
                   site: contest.last)
      end

      update_last_update 'all'
    end

    def codeforces
      # request codeforces api
      contests = JSON.load(open('https://codeforces.com/api/contest.list', 'User-Agent' => USER_AGENT))['result']

      # delete old contests from database
      Codeforces.delete_all

      # add contests
      contests.reverse.each do |contest|
        start_time = Time.strptime(contest['startTimeSeconds'].to_s, '%s')
        Codeforces.create(code: contest['id'].to_i,
                          name: '<a href="https://codeforces.com/contestRegistration/%s" target="_blank">%s</a>' % [contest['id'], contest['name']],
                          start_time: generate_tad_url(start_time),
                          duration: seconds_to_time(contest['durationSeconds'].to_i),
                          in_24_hours: in_24_hours?(start_time),
                          status: contest['phase']) if contest['phase'].eql?('BEFORE') || contest['phase'].eql?('CODING')
      end

      update_last_update 'codeforces'
    end

    def codeforces_gym
      # request codeforces api
      contests = JSON.load(open('https://codeforces.com/api/contest.list?gym=true', 'User-Agent' => USER_AGENT))['result']

      # delete old contests from database
      CodeforcesGym.delete_all

      # add contests
      contests.reverse.each do |contest|
        start_time = contest['startTimeSeconds'].to_s.blank? ? '-' : Time.strptime(contest['startTimeSeconds'].to_s, '%s')
        CodeforcesGym.create(code: contest['id'].to_i,
                             name: '<a href="https://codeforces.com/gymRegistration/%s" target="_blank">%s</a>' % [contest['id'], contest['name']],
                             start_time: start_time.eql?('-') ? start_time : generate_tad_url(start_time),
                             duration: seconds_to_time(contest['durationSeconds'].to_i),
                             difficulty: contest['difficulty'].to_i,
                             in_24_hours: start_time.eql?('-') ? start_time : in_24_hours?(start_time),
                             status: contest['phase']) if contest['phase'].eql?('BEFORE') || contest['phase'].eql?('CODING')
      end

      update_last_update 'codeforces_gym'
    end

    def at_coder
      # request atcoder contests page
      tables = Nokogiri::HTML(open('https://atcoder.jp/contests', 'User-Agent' => USER_AGENT).read).css('.table-default')
      tables.shift
      tables.pop

      # delete old contests from database
      AtCoder.delete_all

      tables.each_with_index do |table, i|

        contests = table.css('tbody > tr')
        # add contests
        contests.each do |contest|
          tds = contest.css('> td')
          start_time = Time.zone.parse("#{tds[0].css('a').first.css('time').text} JST").in_time_zone('UTC')
          a = tds[1].css('a').first
          url = a['href']
          duration = tds[2].text
          rated = tds[3].text
          status = 'BEFORE'
          if start_time < Time.now
            status = 'CODING'
          end
          AtCoder.create(code: url.split('.').first.split('/').last,
                         name: add_target_attr(a.to_s),
                         start_time: generate_tad_url(start_time),
                         duration: duration,
                         rated: rated,
                         in_24_hours: in_24_hours?(start_time),
                         status: status)
        end
      end

      update_last_update 'at_coder'
    end

    def code_chef
      # delete old contests from database
      CodeChef.delete_all

      # request codechef contests page
      tables = Nokogiri::HTML(open('https://www.codechef.com/contests', 'User-Agent' => USER_AGENT).read).css('.dataTable')
      tables.pop
      tables.each_with_index do |table, i|
        contests = table.css('tbody > tr')

        # add contests
        contests.each do |contest|
          tds = contest.css('> td')

          start_time = Time.parse(tds[2]['data-starttime']).in_time_zone('UTC')
          end_time = Time.parse(tds[3]['data-endtime']).in_time_zone('UTC')

          CodeChef.create(code: tds[0].text,
                          name: add_target_attr(tds[1].css('a').to_s.insert(9, 'https://www.codechef.com')),
                          start_time: generate_tad_url(start_time),
                          end_time: generate_tad_url(end_time),
                          duration: seconds_to_time(end_time - start_time),
                          in_24_hours: in_24_hours?(start_time),
                          status: i == 0 ? 'CODING' : 'BEFORE')
        end
      end

      update_last_update 'code_chef'
    end

    def a2oj
      # request a2oj contests page
      tables = Nokogiri::HTML(open('https://a2oj.com/', 'User-Agent' => USER_AGENT).read).css('.tablesorter')
      tables.pop

      # delete old contests from database
      A2oj.delete_all

      tables.each_with_index do |table, i|
        contests = table.css('tbody tr')
        # add contests
        contests.each do |contest|
          tds = contest.css('td')
          code_name = tds[1].text.partition('-')
          code = code_name.first.strip
          name = code_name.last.strip
          owner = add_target_attr(tds[2].css('a').first.to_s.insert(9, 'https://a2oj.com/'))
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
          registrants = add_target_attr(tds[5].css('a').first.to_s.insert(9, 'https://a2oj.com'))
          type = tds[6].text
          if type.eql?('Public')
            registration = add_target_attr(tds[7].css('a').first.to_s.insert(9, 'https://a2oj.com'))
          else
            registration = 'By invitation only'
          end
          A2oj.create(code: code.to_i,
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

      update_last_update 'a2oj'
    end

    def cs_academy
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
      tables = Nokogiri::HTML(browser.html).css('table')
      tables.pop

      status = ['BEFORE']
      if browser.text.include?('Running contests')
        status = ['CODING', 'BEFORE']
      end

      # delete old contests from database
      CsAcademy.delete_all

      tables.each_with_index do |table, i|
        contests = table.css('tbody tr')

        # add contests
        contests.each do |contest|
          tds = contest.css('td')

          start_time = tds[1].text.split(',').first
          start_time += ' '
          start_time += tds[1].text.split('(').last.tr(' UTC)', '')
          start_time = Time.parse(start_time)
          CsAcademy.create(name: add_target_attr(tds[0].css('a').to_s.insert(9, 'https://csacademy.com')),
                           start_time: generate_tad_url(start_time),
                           duration: tds[2].text,
                           in_24_hours: in_24_hours?(start_time),
                           status: status[i])
        end
      end

      browser.close

      update_last_update 'cs_academy'
    end

    def hacker_earth
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
      HackerEarth.delete_all

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

          HackerEarth.create(company: company.blank? ? '-' : company,
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

        HackerEarth.create(company: company.blank? ? '-' : company,
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

    private

    def generate_tad_url start_time
      add_target_attr('<a href="https://www.timeanddate.com/worldclock/fixedtime.html?year=%s&month=%s&day=%s&hour=%s&min=%s&sec=%s&p1=1440">%s</a>' % [start_time.year, start_time.month, start_time.day, start_time.hour, start_time.min, start_time.sec, format_time(start_time)])
    end

    def seconds_to_time seconds
      minutes, seconds = seconds.divmod(60)
      hours, minutes = minutes.divmod(60)
      days, hours = hours.divmod(24)

      if days > 0
        ret = pluralize(days, 'day')
        ret += ' and %02d:%02d:%02d' % [hours, minutes, seconds] if minutes + hours > 0
      else
        ret = '%02d:%02d:%02d' % [hours, minutes, seconds]
      end

      ret
    end

    def add_target_attr anchor
      anchor.insert(3, 'target="_blank" ')
    end

    def in_24_hours? start_time
      (start_time - Time.now) / 60 / 60 <= 24 ? 'Yes' : 'No'
    end

    def format_time time
      time.strftime('%d/%m/%Y %H:%M:%S')
    end

    def update_last_update site_name
      LastUpdate.where(site: site_name).first_or_initialize(site: site_name).update(date: Time.new)
    end
  end
end
