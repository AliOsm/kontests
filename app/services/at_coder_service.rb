class AtCoderService < SiteService
  CONTESTS_URL = 'https://atcoder.jp/contests'
  REQUEST_TYPE = RequestType::HTTP
  DATA_OBJECT_TYPE = DataObjectType::NOKOGIRI

	private

	def extract_contests data
    tables = data.css '.table-default'

    if tables.size == 4
      tables.delete tables[1]
      tables.pop
    elsif data.text.include? 'Upcoming Contests'
      tables.shift
      tables.pop
    else
      tables.pop
      tables.pop
    end

    tables
	end

	def create_contests tables
    tables.each do |table|
      contests = table.css 'tbody > tr'

      contests.each do |contest|
        contest_info = extract_contest_info contest
        create_contest_record contest_info
      end
    end
	end

  def extract_contest_info contest
    tds = contest.css '> td'
    a = tds[1].css('a').first

    contest_info = {}

    contest_info[:name] = a.text
    contest_info[:url] = "https://atcoder.jp#{a['href']}"
    start_time = Time.zone.parse("#{tds[0].css('a').first.css('time').text} JST").in_time_zone('UTC')

    duration = tds[2].text
    hours, minutes = duration.split ':'
    contest_info[:duration] = hours.to_i * SECONDS_IN_HOUR + minutes.to_i * SECONDS_IN_MINUTE

    end_time = start_time + contest_info[:duration]
    contest_info[:rated_range] = tds[3].text
    contest_info[:status] = get_status start_time
    contest_info[:in_24_hours] = in_24_hours? start_time, contest_info[:status]

    contest_info[:start_time] = start_time.strftime UTC_FORMAT
    contest_info[:end_time] = end_time.strftime UTC_FORMAT

    contest_info
  end
end
