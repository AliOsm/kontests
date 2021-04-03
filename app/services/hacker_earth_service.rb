class HackerEarthService < SiteService
  CONTESTS_URL = 'https://www.hackerearth.com/chrome-extension/events'
  REQUEST_TYPE = RequestType::HTTP
  DATA_OBJECT_TYPE = DataObjectType::JSON

	private

	def extract_contests data
    data['response']
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
    contest_info[:url] = contest['url']
    start_time = Time.zone.parse(contest['start_timestamp']).in_time_zone('UTC')
    end_time = Time.zone.parse(contest['end_timestamp']).in_time_zone('UTC')
    contest_info[:duration] = end_time - start_time

    return nil if Time.now > end_time

    contest_info[:type_] = contest['challenge_type']
    contest_info[:status] = get_status start_time
    contest_info[:in_24_hours] = in_24_hours? start_time, contest_info[:status]

    contest_info[:start_time] = start_time.strftime UTC_FORMAT
    contest_info[:end_time] = end_time.strftime UTC_FORMAT

    contest_info
  end
end
