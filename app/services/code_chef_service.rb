class CodeChefService < SiteService
  CONTESTS_URL = 'https://www.codechef.com/contests'

	def update_contests
		response = make_request CONTESTS_URL, RequestType::WATIR

		data = create_data_object response, DataObjectType::NOKOGIRI

    tables = extract_contests data

    CodeChef.delete_all

    create_contests tables

    update_last_update 'code_chef'
	end

	private

	def extract_contests data
    tables = data.css '.dataTable'
    tables.pop
    tables
	end

	def create_contests tables
    tables.each do |table|
      contests = table.css 'tbody > tr'

      contests.each do |contest|
        contest_info = extract_contest_info contest
        create_contest_record CodeChef, contest_info
      end
    end
	end

  def extract_contest_info contest
    tds = contest.css '> td'
    a = tds[1].css('a').first

    contest_info = {}

    contest_info[:name] = a.text
    contest_info[:url] = "https://www.codechef.com#{a['href']}"
    start_time = Time.parse(tds[2]['data-starttime']).in_time_zone('UTC')
    end_time = Time.parse(tds[3]['data-endtime']).in_time_zone('UTC')

    contest_info[:duration] = end_time - start_time
    contest_info[:status] = get_status start_time
    contest_info[:in_24_hours] = in_24_hours? start_time, contest_info[:status]

    contest_info[:start_time] = start_time.strftime UTC_FORMAT
    contest_info[:end_time] = end_time.strftime UTC_FORMAT

    contest_info
  end
end
