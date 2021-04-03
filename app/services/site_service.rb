class SiteService
  include ContestStatus
  include RequestType
  include DataObjectType

  require 'json'
  require 'time'
  require 'watir'
  require 'open-uri'
  require 'nokogiri'

  USER_AGENT = 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0'
  UTC_FORMAT = '%Y-%m-%dT%H:%M:%S.%LZ'

  SECONDS_IN_MINUTE = 60
  SECONDS_IN_HOUR   = SECONDS_IN_MINUTE * 60
  SECONDS_IN_DAY    = SECONDS_IN_HOUR * 24

  def update_contests
    self_service = self.class
    self_model = get_service_model

    response = make_request self_service::CONTESTS_URL, self_service::REQUEST_TYPE

    data = create_data_object response, self_service::DATA_OBJECT_TYPE

    contests = extract_contests data

    self_model.delete_all

    create_contests contests

    update_last_update self_model.name.underscore
  end

  private

  def extract_contests data
    raise NotImplementedError
  end

  def create_contests contests
    raise NotImplementedError
  end

  def extract_contest_info contest
    raise NotImplementedError
  end

  def make_request url, request_type
    case request_type
    when RequestType::DUMMY
      nil
    when RequestType::HTTP
      open(url, 'User-Agent' => USER_AGENT).read
    when RequestType::WATIR
      opts = {
        headless: true
      }

      if chrome_bin = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
        opts.merge!(options: {binary: chrome_bin})
      end

      browser = Watir::Browser.new :chrome, opts

      browser.goto url
      sleep 30.seconds

      html = browser.html

      browser.close

      html
    else
      raise ArgumentError.new("Expected request_type to has one of #{RequestType.values}, got #{request_type}.")
    end
  end

  def create_data_object response, object_type
    case object_type
    when DataObjectType::DUMMY
      response
    when DataObjectType::JSON
      ::JSON.load(response)
    when DataObjectType::NOKOGIRI
      Nokogiri::HTML(response)
    else
      raise ArgumentError.new("Expected object_type to has one of #{DataObjectType.values}, got #{object_type}.")
    end
  end

  def update_last_update site_name
    LastUpdate.where(site: site_name).first_or_initialize(site: site_name).update(date: Time.new)
  end

  def create_contest_record params
    get_service_model.create(params)
  end

	def in_24_hours? start_time, status
    if status.eql? ContestStatus::CODING
      'No'
    else
      (start_time - Time.now.in_time_zone('UTC')) / SECONDS_IN_HOUR <= 24 ? 'Yes' : 'No'
    end
  end

  def get_status start_time
    start_time < Time.now.in_time_zone('UTC') ? ContestStatus::CODING : ContestStatus::BEFORE
  end

  def get_service_model
    self.class.name.sub('Service', '').constantize
  end
end
