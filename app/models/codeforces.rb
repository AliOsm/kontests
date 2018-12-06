class Codeforces < ApplicationRecord
	self.primary_key = :code

	def to_param
		code.parametarize
	end
end
