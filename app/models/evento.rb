class Evento < ActiveRecord::Base
	serialize :grupos_pertenece, Array
	serialize :grupos_dirigidos, Array
	belongs_to :usuario
	has_and_belongs_to_many :grupos

	  def aprobado?(grupo_id)
	    grupos_dirigidos.each do |grupo|
	      if grupo_id.to_s == grupo
	        return true
	      end
	    end
	    return false
	  end

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
