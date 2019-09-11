class HackerRankService < SiteService
  CONTESTS_URL1 = 'https://www.hackerrank.com/rest/contests/upcoming?limit=100'
  CONTESTS_URL2 = 'https://www.hackerrank.com/rest/contests/college?limit=100'

	def update_contests
    response1 = make_request CONTESTS_URL1, RequestType::HTTP
		response2 = make_request CONTESTS_URL2, RequestType::HTTP

    data1 = create_data_object response1, DataObjectType::JSON
    data2 = create_data_object response2, DataObjectType::JSON

    contests = extract_contests data1, data2

    HackerRank.delete_all

    create_contests contests

    update_last_update 'hacker_rank'
	end

	private

	def extract_contests data1, data2
    data1 = data1['models']
    data1.each do |element|
      element[:type_] = 'Regular'
    end

    data2 = data2['models']
    data2.each do |element|
      element[:type_] = 'College'
    end

    data = data1 + data2
    data.sort_by! { |element| element['epoch_starttime'] }
    data
	end

	def create_contests contests
		contests.each do |contest|
      contest_info = extract_contest_info contest
      next if contest_info.nil?
      create_contest_record HackerRank, contest_info
    end
	end

  def extract_contest_info contest
    contest_info = {}

    contest_info[:name] = contest['name']
    contest_info[:url] = "https://hackerrank.com/contests/#{contest['slug']}"
    start_time = DateTime.strptime(contest['epoch_starttime'].to_s, '%s')
    start_time = Time.parse start_time.to_s
    end_time = DateTime.strptime(contest['epoch_endtime'].to_s, '%s')
    end_time = Time.parse end_time.to_s

    return nil if Time.now > end_time

    contest_info[:duration] = end_time - start_time
    contest_info[:type_] = contest[:type_]
    contest_info[:status] = get_status start_time
    contest_info[:in_24_hours] = in_24_hours? start_time, contest_info[:status]

    contest_info[:start_time] = start_time.strftime UTC_FORMAT
    contest_info[:end_time] = end_time.strftime UTC_FORMAT

    contest_info
  end
end
