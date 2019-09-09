require 'json'
require 'time'
require 'watir'
require 'open-uri'
require 'nokogiri'

module UpdateSitesService
  USER_AGENT = 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0'

  class << self
    def all
      # prepare contests
      all_contests = SITES[1..-1].map do |site|
        site.second.camelize.constantize.pluck(:name, :url, :start_time, :end_time, :duration, :in_24_hours, :status)
      end

      SITES[1..-1].each_with_index do |site, i|
        all_contests[i].each do |contest|
          contest << site.first
        end
      end

      all_contests.compact!
      all_contests = all_contests.flatten(1)

      all_contests.sort! do |a, b|
        if a[2].eql?('-')
          1
        elsif b[2].eql?('-')
          -1
        else
          Time.parse(a[2]) <=> Time.parse(b[2])
        end
      end

      # delete old contests from database
      All.delete_all

      # add contests
      all_contests.each do |contest|
        All.create(
          name: contest[0],
          url: contest[1],
          start_time: contest[2],
          end_time: contest[3],
          duration: contest[4],
          in_24_hours: contest[5],
          status: contest[6],
          site: contest[7]
        )
      end

      update_last_update 'all'
    end

    def codeforces
      # request codeforces api
      contests = JSON.load(
        open(
          'https://codeforces.com/api/contest.list',
          'User-Agent' => USER_AGENT
        )
      )['result']

      # delete old contests from database
      Codeforces.delete_all

      # add contests
      contests.reverse.each do |contest|
        next unless ['BEFORE', 'CODING'].include?(contest['phase'])

        code = contest['id'].to_i
        name = contest['name']
        url = "https://codeforces.com/contestRegistration/#{code}"
        duration = contest['durationSeconds'].to_i
        status = contest['phase']

        if contest['startTimeSeconds'].blank?
          start_time = '-'
          end_time = '-'
          in_24_hours = 'No'
        else
          start_time = DateTime.strptime(contest['startTimeSeconds'].to_s, '%s')
          start_time = Time.parse(start_time.to_s)
          end_time = start_time + duration
          in_24_hours = in_24_hours?(start_time, status)

          start_time = start_time.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
          end_time = end_time.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
        end

        Codeforces.create(
          code: code,
          name: name,
          url: url,
          start_time: start_time,
          end_time: end_time,
          duration: duration,
          in_24_hours: in_24_hours,
          status: status
        )
      end

      update_last_update 'codeforces'
    end

    def codeforces_gym
      # request codeforces_gym api
      contests = JSON.load(
        open(
          'https://codeforces.com/api/contest.list?gym=true',
          'User-Agent' => USER_AGENT
        )
      )['result']

      # delete old contests from database
      CodeforcesGym.delete_all

      # add contests
      contests.reverse.each do |contest|
        next unless ['BEFORE', 'CODING'].include?(contest['phase'])

        code = contest['id'].to_i
        name = contest['name']
        url = "https://codeforces.com/gymRegistration/#{code}"
        duration = contest['durationSeconds'].to_i
        difficulty = contest['difficulty'].to_i
        status = contest['phase']

        if contest['startTimeSeconds'].blank?
          start_time = '-'
          end_time = '-'
          in_24_hours = 'No'
        else
          start_time = DateTime.strptime(contest['startTimeSeconds'].to_s, '%s')
          start_time = Time.parse(start_time.to_s)
          end_time = start_time + duration
          in_24_hours = in_24_hours?(start_time, status)

          start_time = start_time.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
          end_time = end_time.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
        end

        CodeforcesGym.create(
          code: code,
          name: name,
          url: url,
          start_time: start_time,
          end_time: end_time,
          duration: duration,
          difficulty: difficulty,
          in_24_hours: in_24_hours,
          status: status
        )
      end

      update_last_update 'codeforces_gym'
    end

    def at_coder
      # request at_coder contests page
      html = Nokogiri::HTML(
        open(
          'https://atcoder.jp/contests',
          'User-Agent' => USER_AGENT
        ).read
      )
      tables = html.css('.table-default')

      if tables.size == 4
        tables.delete(tables[1])
        tables.pop
      elsif html.text.include? 'Upcoming Contests'
        tables.shift
        tables.pop
      else
        tables.pop
        tables.pop
      end

      # delete old contests from database
      AtCoder.delete_all

      tables.each do |table|
        contests = table.css('tbody > tr')

        # add contests
        contests.each do |contest|
          tds = contest.css('> td')
          a = tds[1].css('a').first

          code = a['href'].split('.').first.split('/').last
          name = a.text
          url = 'https://atcoder.jp%s' % [a['href']]
          start_time = Time.zone.parse("#{tds[0].css('a').first.css('time').text} JST").in_time_zone('UTC')

          duration = tds[2].text
          hours, minutes = duration.split(':')
          seconds = hours.to_i * 60 * 60 + minutes.to_i * 60

          end_time = start_time + seconds
          rated_range = tds[3].text
          status = start_time < Time.now ? 'CODING' : 'BEFORE'
          in_24_hours = in_24_hours?(start_time, status)

          start_time = start_time.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
          end_time = end_time.strftime('%Y-%m-%dT%H:%M:%S.%LZ')

          AtCoder.create(
            code: code,
            name: name,
            url: url,
            start_time: start_time,
            end_time: end_time,
            duration: seconds,
            rated_range: rated_range,
            in_24_hours: in_24_hours,
            status: status
          )
        end
      end

      update_last_update 'at_coder'
    end

    def code_chef
      # request code_chef contests page
      tables = Nokogiri::HTML(
        open(
          'https://www.codechef.com/contests',
          'User-Agent' => USER_AGENT
        ).read
      ).css('.dataTable')
      tables.pop

      # delete old contests from database
      CodeChef.delete_all

      tables.each do |table|
        contests = table.css('tbody > tr')

        # add contests
        contests.each do |contest|
          tds = contest.css('> td')
          a = tds[1].css('a').first

          code = tds[0].text
          name = a.text
          url = 'https://www.codechef.com%s' % [a['href']]
          start_time = Time.parse(tds[2]['data-starttime']).in_time_zone('UTC')
          end_time = Time.parse(tds[3]['data-endtime']).in_time_zone('UTC')

          duration = end_time - start_time
          status = start_time < Time.now ? 'CODING' : 'BEFORE'
          in_24_hours = in_24_hours?(start_time, status)

          start_time = start_time.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
          end_time = end_time.strftime('%Y-%m-%dT%H:%M:%S.%LZ')

          CodeChef.create(
            code: code,
            name: name,
            url: url,
            start_time: start_time,
            end_time: end_time,
            duration: duration,
            in_24_hours: in_24_hours,
            status: status
          )
        end
      end

      update_last_update 'code_chef'
    end

    def cs_academy
      opts = {
        headless: true
      }

      if chrome_bin = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
        opts.merge!(options: {binary: chrome_bin})
      end

      browser = Watir::Browser.new :chrome, opts

      # request cs_academy contests page
      browser.goto 'https://csacademy.com/contests'
      browser.wait_until { browser.element(css: 'table').exists? } rescue false
      tables = Nokogiri::HTML(browser.html).css('table')
      tables.pop

      # delete old contests from database
      CsAcademy.delete_all

      tables.each_with_index do |table, i|
        contests = table.css('tbody tr')

        # add contests
        contests.each do |contest|
          tds = contest.css('td')
          a = tds[0].css('a').first

          name = a.text
          url = 'https://csacademy.com%s' % [a['href']]
          start_time = tds[1].text.split(',').first
          start_time += ' '
          start_time += tds[1].text.split('(').last.tr(' UTC)', '')
          start_time = Time.zone.parse(start_time + ' UTC')

          hours, minutes = tds[2].text.split(' ').select { |elem| elem.scan(/\D/).empty? }.map(&:to_i)
          minutes = 0 if minutes.nil?
          seconds = hours * 60 * 60 + minutes * 60

          end_time = start_time + seconds
          status = start_time < Time.now ? 'CODING' : 'BEFORE'
          in_24_hours = in_24_hours?(start_time, status)

          start_time = start_time.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
          end_time = end_time.strftime('%Y-%m-%dT%H:%M:%S.%LZ')

          CsAcademy.create(
            name: name,
            url: url,
            start_time: start_time,
            end_time: end_time,
            duration: seconds,
            in_24_hours: in_24_hours,
            status: status
          )
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
      browser.wait_until { browser.element(css: '.ongoing').exists? } rescue false
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
          end_time = end_time.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
        end

        end_time = '-' if end_time.nil?
        type_ = card.css('.challenge-type').text.strip

        unless end_time.nil?
          company = card.css('.company-details').text.strip
          name = card.css('.challenge-name').text.strip
          url = card.css('.challenge-card-wrapper').first['href']
          url = 'https://www.hackerearth.com' + url unless url.include? 'https://www.hackerearth.com'

          HackerEarth.create(
            company: company.blank? ? '-' : company,
            name: name,
            url: url,
            start_time: '-',
            end_time: end_time,
            duration: '-',
            type_: type_,
            in_24_hours: 'No',
            status: 'CODING'
          )
        end
      end

      # add contests
      cards = html.css('.upcoming').css('.challenge-card-modern')
      cards.each do |card|
        company = card.css('.company-details').text.strip
        start_time = Time.parse(card.css('.challenge-desc .date').text).in_time_zone('UTC')

        name = card.css('.challenge-name').text.strip
        url = card.css('.challenge-card-wrapper').first['href']
        url = 'https://www.hackerearth.com' + url unless url.include? 'https://www.hackerearth.com'
        type_ = card.css('.challenge-type').text.strip
        in_24_hours = in_24_hours?(start_time, 'BEFORE')

        start_time = start_time.strftime('%Y-%m-%dT%H:%M:%S.%LZ')

        HackerEarth.create(
          company: company.blank? ? '-' : company,
          name: name,
          url: url,
          start_time: start_time,
          end_time: '-',
          duration: '-',
          type_: type_,
          in_24_hours: in_24_hours,
          status: 'BEFORE'
        )
      end

      browser.close

      update_last_update 'hacker_earth'
    end

    def leet_code
      opts = {
        headless: true
      }

      if chrome_bin = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
        opts.merge!(options: {binary: chrome_bin})
      end

      browser = Watir::Browser.new :chrome, opts

      # request leet_code contests page
      browser.goto 'https://leetcode.com/contest'
      browser.wait_until { browser.element(css: '.contest-card-base').exists? } rescue false
      sleep 5.seconds
      contests = Nokogiri::HTML(browser.html).css('.contest-card-base')

      # delete old contests from database
      LeetCode.delete_all

      # add contests
      contests.each do |contest|
        a = contest.css('div a').first
        next if a.nil?

        name = a.css('.card-title').first.text
        url = 'https://leetcode.com%s' % [a['href']]

        date, time = a.css('.time').text.split('@')
        time = time.split('-')

        start_time = date.strip + ' ' + time[0].strip()
        start_time = Time.strptime(start_time, '%b %d, %Y %l:%M %P').in_time_zone('UTC')

        end_time = date.strip + ' ' + time[1].strip()
        end_time = Time.strptime(end_time, '%b %d, %Y %l:%M %P').in_time_zone('UTC')

        duration = end_time - start_time

        status = start_time < Time.now ? 'CODING' : 'BEFORE'
        in_24_hours = in_24_hours?(start_time, status)

        start_time = start_time.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
        end_time = end_time.strftime('%Y-%m-%dT%H:%M:%S.%LZ')

        LeetCode.create(
          name: name,
          url: url,
          start_time: start_time,
          end_time: end_time,
          duration: duration,
          in_24_hours: in_24_hours,
          status: status
        )
      end

      browser.close

      update_last_update 'leet_code'
    end

    def a2oj
      # request a2oj contests page
      tables = Nokogiri::HTML(
        open(
          'https://a2oj.com/',
          'User-Agent' => USER_AGENT
        ).read
      ).css('.tablesorter')
      tables.pop

      # delete old contests from database
      A2oj.delete_all

      tables.each do |table|
        contests = table.css('tbody tr')

        # add contests
        contests.each do |contest|
          tds = contest.css('td')

          code_name = tds[1].text.partition('-')
          code = code_name.first.strip.to_i
          name = code_name.last.strip
          owner_a = tds[2].css('a').first
          owner_name = owner_a.text
          owner_url = 'https://a2oj.com/%s' % [owner_a['href']]
          start_time = Time.zone.parse(tds[3].css('a').first.text + ' UTC')
          status = start_time < Time.now ? 'CODING' : 'BEFORE'

          duration = tds[4].text
          # special case for running contests
          duration.remove!(tds[4].css('b').text) if status.eql?('CODING')

          days = nil
          hours = nil
          minutes = nil

          if duration.include? 'day' or duration.include? 'days'
            days, hours, minutes = duration.split(' ').select { |elem| elem.scan(/\D/).empty? }.map(&:to_i)
          elsif duration.include? 'hr' or duration.include? 'hrs'
            hours, minutes = duration.split(' ').select { |elem| elem.scan(/\D/).empty? }.map(&:to_i)
          elsif duration.include? 'mins'
            minutes = duration.split(' ').select { |elem| elem.scan(/\D/).empty? }.map(&:to_i)
          end

          days = 0 if days.nil?
          hours = 0 if hours.nil?
          minutes = 0 if minutes.nil?

          seconds = days * 24 * 60 * 60 + hours * 60 * 60 + minutes * 60

          end_time = start_time + seconds

          registrants = tds[5].css('a').first.text
          type = tds[6].text
          if type.eql?('Public')
            url = 'https://a2oj.com/%s' % [tds[7].css('a').first['href']]
          else
            next
          end

          in_24_hours = in_24_hours?(start_time, status)

          start_time = start_time.strftime('%Y-%m-%dT%H:%M:%S.%LZ')
          end_time = end_time.strftime('%Y-%m-%dT%H:%M:%S.%LZ')

          A2oj.create(
            code: code,
            name: name,
            url: url,
            start_time: start_time,
            end_time: end_time,
            duration: seconds,
            owner_name: owner_name,
            owner_url: owner_url,
            registrants: registrants,
            in_24_hours: in_24_hours,
            status: status
          )
        end
      end

      update_last_update 'a2oj'
    end

    private

    def in_24_hours? start_time, status
      if status.eql? 'CODING'
        'No'
      else
        (start_time - Time.now.in_time_zone('UTC')) / 60 / 60 <= 24 ? 'Yes' : 'No'
      end
    end

    def update_last_update site_name
      LastUpdate.where(site: site_name).first_or_initialize(site: site_name).update(date: Time.new)
    end
  end
end
