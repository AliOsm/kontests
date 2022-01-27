class LeetCodeService < SiteService
  CONTESTS_URL = 'https://leetcode.com/graphql?query={%20allContests%20{%20title%20titleSlug%20startTime%20duration%20__typename%20}%20}'
  REQUEST_TYPE = RequestType::HTTP
  DATA_OBJECT_TYPE = DataObjectType::JSON

	private

	def extract_contests data
    data['data']['allContests']
	end

	def create_contests contests
		contests.each do |contest|
      contest_info = extract_contest_info contest
      next if contest_info.nil?
      create_contest_record contest_info
    end
	end

  def extract_contest_info contest
    contest_info = {}

    contest_info[:name] = contest['title']
    contest_info[:url] = "https://leetcode.com/contest/#{contest['title_slug']}"
    contest_info[:duration] = contest['duration'].to_i

    start_time = DateTime.strptime contest['startTime'].to_s, '%s'
    start_time = Time.parse start_time.to_s
    end_time = start_time + contest_info[:duration]

    return nil if Time.now > end_time

    contest_info[:status] = get_status start_time
    contest_info[:in_24_hours] = in_24_hours? start_time, contest_info[:status]

    contest_info[:start_time] = start_time.strftime UTC_FORMAT
    contest_info[:end_time] = end_time.strftime UTC_FORMAT

    contest_info
  end
end
