class CodeforcesService < SiteService
  CONTESTS_URL = 'https://codeforces.com/api/contest.list'

	def update_contests
		response = make_request CONTESTS_URL, RequestType::HTTP

		data = create_data_object response, DataObjectType::JSON

    contests = extract_contests data

    Codeforces.delete_all

    create_contests contests

    update_last_update 'codeforces'
	end

	private

	def extract_contests data
    data['result']
	end

	def create_contests contests
		contests.reverse.each do |contest|
      next unless ContestStatus.values.include? contest['phase'].to_sym
      contest_info = extract_contest_info contest
      create_contest_record Codeforces, contest_info
    end
	end

  def extract_contest_info contest
    contest_info = {}

    contest_info[:name] = contest['name']
    contest_info[:url] = "https://codeforces.com/contestRegistration/#{contest['id'].to_i}"
    contest_info[:duration] = contest['durationSeconds'].to_i
    contest_info[:status] = contest['phase']

    if contest['startTimeSeconds'].blank?
      start_time = '-'
      end_time = '-'
      in_24_hours = 'No'
    else
      start_time = DateTime.strptime contest['startTimeSeconds'].to_s, '%s'
      start_time = Time.parse start_time.to_s
      end_time = start_time + contest_info[:duration]
      in_24_hours = in_24_hours? start_time, contest_info[:status]

      start_time = start_time.strftime UTC_FORMAT
      end_time = end_time.strftime UTC_FORMAT
    end

    contest_info[:start_time] = start_time
    contest_info[:end_time] = end_time
    contest_info[:in_24_hours] = in_24_hours

    contest_info
  end
end
