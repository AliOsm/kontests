require 'json'
require 'nokogiri'

module Parsers
	def self.dummy_parse response
		response
	end

	def self.json_parse response
		JSON.load(response)
	end

	def self.nokogiri_parse response
		Nokogiri::HTML(response)
	end
end
