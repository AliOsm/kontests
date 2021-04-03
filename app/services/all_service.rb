class AllService < SiteService
  CONTESTS_URL = 'dummy'
  REQUEST_TYPE = RequestType::DUMMY
  DATA_OBJECT_TYPE = DataObjectType::DUMMY

	private

  def make_request url, request_type
    SITES[1..-1].map do |site|
      site.second.camelize.constantize.pluck(
        :name,
        :url,
        :start_time,
        :end_time,
        :duration,
        :in_24_hours,
        :status
      )
    end
  end

	def extract_contests data
    SITES[1..-1].each_with_index do |site, i|
      data[i].each do |contest|
        contest << site.first
      end
    end

    data.compact!
    data = data.flatten(1)

    data.sort! do |a, b|
      if a[2].eql?('-')
        1
      elsif b[2].eql?('-')
        -1
      else
        Time.parse(a[2]) <=> Time.parse(b[2])
      end
    end
	end

	def create_contests contests
		contests.each do |contest|
      contest_info = extract_contest_info contest
      create_contest_record contest_info
    end
	end

  def extract_contest_info contest
    contest_info = {}

    contest_info[:name] = contest[0]
    contest_info[:url] = contest[1]
    contest_info[:start_time] = contest[2]
    contest_info[:end_time] = contest[3]
    contest_info[:duration] = contest[4]
    contest_info[:in_24_hours] = contest[5]
    contest_info[:status] = contest[6]
    contest_info[:site] = contest[7]

    contest_info
  end
end
