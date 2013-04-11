module ApplicationHelper
	def full_title(page_title)
		base_title = "Universidad Complutense Microposts Service"
		if page_title.empty?
			base_title	# Implicit return
		else
			"#{base_title} | #{page_title}" # String interpolation
		end
	end
end
