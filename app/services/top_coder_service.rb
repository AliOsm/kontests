class TopCoderService < SiteService
  CONTESTS_URL = 'https://clients6.google.com/calendar/v3/calendars/appirio.com_bhga3musitat85mhdrng9035jg@group.calendar.google.com/events?calendarId=appirio.com_bhga3musitat85mhdrng9035jg%40group.calendar.google.com&timeMin=2019-01-01T00%3A00%3A00-04%3A00&key=AIzaSyBNlYH01_9Hc5S1J9vuFmu2nUqBZJNAXxs'
  REQUEST_TYPE = RequestType::HTTP
  DATA_OBJECT_TYPE = DataObjectType::JSON

	private

	def extract_contests data
    data = data['items']
    data.select! { |element| not element['start'].nil? and not element['start']['dateTime'].nil? }
    data.sort_by! { |element| Time.parse(element['start']['dateTime']).in_time_zone('UTC') }
    data
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

    contest_info[:name] = contest['summary']
    contest_info[:url] = 'https://www.topcoder.com/challenges'

    start_time = Time.parse(contest['start']['dateTime']).in_time_zone('UTC')
    end_time = Time.parse(contest['end']['dateTime']).in_time_zone('UTC')

    return nil if Time.now > end_time

    contest_info[:duration] = end_time - start_time
    contest_info[:status] = get_status start_time
    contest_info[:in_24_hours] = in_24_hours? start_time, contest_info[:status]

    contest_info[:start_time] = start_time.strftime UTC_FORMAT
    contest_info[:end_time] = end_time.strftime UTC_FORMAT

    contest_info
  end
end
