require 'open-uri'

module PingService
  USER_AGENT = 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0'

  def self.ping
    open('https://kontests.net', 'User-Agent' => USER_AGENT)
  end
end
