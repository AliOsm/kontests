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
  SECONDS_IN_DAY = 24 * 60 * 60
  SECONDS_IN_HOUR = 60 * 60
  SECONDS_IN_MINUTE = 60

  def self.update_contests
    new.update_contests
  end

  private

  def make_request url, request_type
    if request_type.eql? RequestType::HTTP
      open(
        url,
        'User-Agent' => USER_AGENT
      ).read
    elsif request_type.eql? RequestType::WATIR
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
      raise ArgumentError
    end
  end

  def create_data_object response, object_type
    if object_type.eql? DataObjectType::JSON
      ::JSON.load(response)
    elsif object_type.eql? DataObjectType::NOKOGIRI
      Nokogiri::HTML(response)
    else
      raise ArgumentError
    end
  end

  def extract_contests data
    raise NotImplementedError
  end

  def create_contests contests
    raise NotImplementedError
  end

  def extract_contest_info contest
    raise NotImplementedError
  end

  def create_contest_record model, params
    model.create(params)
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

  def update_last_update site_name
    LastUpdate.where(site: site_name).first_or_initialize(site: site_name).update(date: Time.new)
  end
end
