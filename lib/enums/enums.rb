module Enums
	def values
		self.constants.map { |c| self.const_get(c) }
	end
end
