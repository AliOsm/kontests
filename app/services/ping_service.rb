module PingService
  include Requesters

  def self.ping
    Requesters.http_request 'https://kontests.net'
  end
end
