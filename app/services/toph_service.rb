class TophService < SiteService
  CONTESTS_URL = 'https://toph.co/contests'
  REQUEST_TYPE = RequestType::HTTP
  DATA_OBJECT_TYPE = DataObjectType::NOKOGIRI

  CONTESTS_CONTAINER_INDEX = 2

	private

	def extract_contests data
		container = data.css('.container')[CONTESTS_CONTAINER_INDEX]
		row = container.css('.row').first
		col_md_9 = row.css('.col-md-9').first
		panels = col_md_9.css '.panel'
		panels
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

		contest_info[:name] = contest.css('.caption h2').text
		contest_info[:url] = "https://toph.co#{contest.css('.caption').first['href']}"

		start_time = DateTime.strptime contest.css('.timestamp').first['data-time'].to_s, '%s'
    start_time = Time.parse start_time.to_s
    contest_info[:start_time] = start_time.strftime UTC_FORMAT
    contest_info[:is_rated] = is_rated? contest
    contest_info[:is_official] = is_official? contest
    contest_info[:status] = get_status contest_info[:start_time]
    contest_info[:in_24_hours] = in_24_hours? start_time, contest_info[:status]

    # I'm putting dummy values here to keep the general interface common between all website.
    # These values should be gotten from the website either by searching for an API or crawling
    # the contest's page itself, which will require more computation.
    contest_info[:end_time] = contest_info[:start_time]
    contest_info[:duration] = start_time - start_time

		contest_info
	rescue
		nil
	end

	def is_rated? contest
		contest.text.include?('Rated') ? 'Yes' : 'No'
	end

	def is_official? contest
		contest.text.include?('Official') ? 'Yes' : 'No'
	end
end
