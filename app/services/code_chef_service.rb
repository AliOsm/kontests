class CodeChefService < SiteService
  CONTESTS_URL = 'https://www.codechef.com/api/list/contests/all?sort_by=START&sorting_order=asc&offset=0&mode=all'
  REQUEST_TYPE = RequestType::HTTP
  DATA_OBJECT_TYPE = DataObjectType::JSON

	private

	def extract_contests data
    # Should practice_contests be added to the list? e.g. ` + data['practice_contests']`
    data['present_contests'] + data['future_contests']
	end

	def create_contests contests
    contests.reverse.each do |contest|
      contest_info = extract_contest_info contest
      create_contest_record contest_info
    end
	end

  def extract_contest_info contest
    contest_info = {}

    contest_info[:name] = contest['contest_name']
    contest_info[:url] = "https://www.codechef.com/#{contest['contest_code']}"
    contest_info[:duration] = contest['contest_duration'].to_i * SECONDS_IN_MINUTE

    contest_info[:start_time] = Time.parse(contest['contest_start_date_iso']).in_time_zone('UTC')

    if contest.key?('contest_end_date_iso')
      contest_info[:end_time] = Time.parse(contest['contest_end_date_iso']).in_time_zone('UTC')
    else
      contest_info[:end_time] = contest_info[:start_time] + 10.years
      contest_info[:duration] = contest_info[:end_time] - contest_info[:start_time]
    end

    contest_info[:status] = get_status contest_info[:start_time]
    contest_info[:in_24_hours] = in_24_hours? contest_info[:start_time], contest_info[:status]

    contest_info
  end
end
