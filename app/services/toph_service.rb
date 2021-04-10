class TophService < SiteService
  CONTESTS_URL = 'https://toph.co'
  REQUEST_TYPE = RequestType::HTTP
  DATA_OBJECT_TYPE = DataObjectType::NOKOGIRI

	private

	def extract_contests data
	end

	def create_contests tables
	end

	def extract_contest_info contest
	end
end
