module ApplicationHelper
	def theme
		cookies[:theme].nil? ? 'default' : cookies[:theme]
	end
end
