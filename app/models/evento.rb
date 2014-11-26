class Evento < ActiveRecord::Base
	serialize :grupos_pertenece, Array
	belongs_to :usuario
	has_and_belongs_to_many :grupos

	def pertenece_misgrupos(id,user)
		evento = Evento.find(id)
		value = false
		user.misgrupos.each do |grupo|
			evento.grupos_pertenece.each do |gr_pert|
				if grupo.to_s == gr_pert
					value = true
				end
			end
		end
		return value
	end
end
