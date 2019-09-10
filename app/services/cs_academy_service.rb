class CsAcademyService < SiteService
  CONTESTS_URL = 'https://csacademy.com/contests'

	def update_contests
		response = make_request CONTESTS_URL, RequestType::WATIR

		data = create_data_object response, DataObjectType::NOKOGIRI

    tables = extract_contests data

    CsAcademy.delete_all

    create_contests tables

    update_last_update 'cs_academy'
	end

	private

	def extract_contests data
    tables = data.css 'table'
    tables.pop
    tables
	end

	def create_contests tables
    tables.each do |table|
      contests = table.css 'tbody tr'

      contests.each do |contest|
        contest_info = extract_contest_info contest
        create_contest_record CsAcademy, contest_info
      end
    end
	end

  def extract_contest_info contest
    tds = contest.css 'td'
    a = tds[0].css('a').first

    contest_info = {}

    contest_info[:name] = a.text
    contest_info[:url] = "https://csacademy.com#{a['href']}"
    start_time = tds[1].text.split(',').first
    start_time += ' '
    start_time += tds[1].text.split('(').last.tr(' UTC)', '')
    start_time = Time.zone.parse(start_time + ' UTC')

    hours, minutes = tds[2].text.split(' ').select { |elem| elem.scan(/\D/).empty? }.map(&:to_i)
    minutes = 0 if minutes.nil?
    contest_info[:duration] = hours * SECONDS_IN_HOUR + minutes * SECONDS_IN_MINUTE

    end_time = start_time + contest_info[:duration]
    contest_info[:status] = get_status start_time
    contest_info[:in_24_hours] = in_24_hours? start_time, contest_info[:status]

    contest_info[:start_time] = start_time.strftime UTC_FORMAT
    contest_info[:end_time] = end_time.strftime UTC_FORMAT

    contest_info
  end
end
