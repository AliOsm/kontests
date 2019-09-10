class A2ojService < SiteService
  CONTESTS_URL = 'https://a2oj.com'

	def update_contests
		response = make_request CONTESTS_URL, RequestType::HTTP

		data = create_data_object response, DataObjectType::NOKOGIRI

    tables = extract_contests data

    A2oj.delete_all

    create_contests tables

    update_last_update 'a2oj'
	end

	private

	def extract_contests data
    tables = data.css '.tablesorter'
    tables.pop
    tables
	end

	def create_contests tables
    tables.each do |table|
      contests = table.css 'tbody tr'

      contests.each do |contest|
        contest_info = extract_contest_info contest
        next if contest_info.nil?
        create_contest_record A2oj, contest_info
      end
    end
	end

  def extract_contest_info contest
    tds = contest.css 'td'

    contest_info = {}

    if tds[6].text.eql? 'Public'
      contest_info[:url] = "https://a2oj.com/#{tds[7].css('a').first['href']}"
    else
      return nil
    end

    code_name = tds[1].text.partition '-'
    contest_info[:name] = code_name.last.strip
    owner_a = tds[2].css('a').first
    contest_info[:owner_name] = owner_a.text
    contest_info[:owner_url] = "https://a2oj.com/#{owner_a['href']}"
    start_time = Time.zone.parse(tds[3].css('a').first.text + ' UTC')
    contest_info[:status] = get_status start_time

    duration = tds[4].text
    # special case for running contests
    duration.remove!(tds[4].css('b').text) if contest_info[:status].eql? ContestStatus::CODING

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

    contest_info[:duration] = days * SECONDS_IN_DAY + hours * SECONDS_IN_HOUR + minutes * SECONDS_IN_MINUTE

    end_time = start_time + contest_info[:duration]

    contest_info[:registrants] = tds[5].css('a').first.text
    contest_info[:in_24_hours] = in_24_hours? start_time, contest_info[:status]

    contest_info[:start_time] = start_time.strftime UTC_FORMAT
    contest_info[:end_time] = end_time.strftime UTC_FORMAT

    contest_info
  end
end
