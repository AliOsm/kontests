require 'watir'
require 'open-uri'

module Requesters
  USER_AGENT = 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0'

  def self.dummy_request url
  	nil
  end

  def self.http_request url
		open(url, 'User-Agent' => USER_AGENT).read
  end

  def self.watir_request url
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
  end
end
