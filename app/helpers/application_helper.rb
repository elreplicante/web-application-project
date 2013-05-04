#encoding: UTF-8

module ApplicationHelper
	def full_title(page_title)
		base_title = "Servicio de Microposts de la Facultad de Informática"
		if page_title.empty?
			base_title	# Implicit return
		else
			"#{base_title} | #{page_title}" # String interpolation
		end
	end
end
