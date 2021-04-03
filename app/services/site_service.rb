class SiteService
  include Requesters
  include Parsers

  include ContestStatus
  include RequestType
  include DataObjectType

  require 'time'

  UTC_FORMAT = '%Y-%m-%dT%H:%M:%S.%LZ'

  SECONDS_IN_MINUTE = 60
  SECONDS_IN_HOUR   = SECONDS_IN_MINUTE * 60
  SECONDS_IN_DAY    = SECONDS_IN_HOUR * 24

  def update_contests
    response = make_request self.class::CONTESTS_URL, self.class::REQUEST_TYPE

    data = create_data_object response, self.class::DATA_OBJECT_TYPE

    contests = extract_contests data

    service_model.delete_all

    create_contests contests

    update_last_update service_model.name.underscore
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
    if RequestType.values.include? request_type
      Requesters.send("#{request_type}_request", url)
    else
      raise ArgumentError.new("Expected request_type to has one of #{RequestType.values} values, got #{request_type}.")
    end
  end

  def create_data_object response, object_type
    if DataObjectType.values.include? object_type
      Parsers.send("#{object_type}_parse", response)
    else
      raise ArgumentError.new("Expected object_type to has one of #{DataObjectType.values} values, got #{object_type}.")
    end
  end

  def update_last_update site_name
    LastUpdate.where(site: site_name).first_or_initialize(site: site_name).update(date: Time.new)
  end

  def create_contest_record params
    service_model.create(params)
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

  def service_model
    self.class.name.sub('Service', '').constantize
  end
end
