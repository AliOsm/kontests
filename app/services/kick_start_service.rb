class KickStartService < SiteService
  CONTESTS_URL = 'https://codingcompetitions.withgoogle.com/kickstart/schedule'

	def update_contests
		response = make_request CONTESTS_URL, RequestType::WATIR

		data = create_data_object response, DataObjectType::NOKOGIRI

    contests = extract_contests data

    KickStart.delete_all

    create_contests contests

    update_last_update 'kick_start'
	end

	private

	def extract_contests data
    data.css '.schedule-row__upcoming'
	end

	def create_contests contests
    contests.each do |contest|
      contest_info = extract_contest_info contest
      create_contest_record KickStart, contest_info
    end
	end

  def extract_contest_info contest
    contest_info = {}

    contest_info[:name] = contest.css('div span').first.text
    contest_info[:url] = 'https://codingcompetitions.withgoogle.com/kickstart/schedule'
    start_time = Time.zone.parse contest.css('div')[1].first_element_child.text + ' UTC'
    end_time = Time.zone.parse contest.css('div')[2].first_element_child.text + ' UTC'
    contest_info[:duration] = end_time - start_time
    contest_info[:status] = get_status start_time
    contest_info[:in_24_hours] = in_24_hours? start_time, contest_info[:status]

    contest_info[:start_time] = start_time.strftime UTC_FORMAT
    contest_info[:end_time] = end_time.strftime UTC_FORMAT

    contest_info
  end
end
