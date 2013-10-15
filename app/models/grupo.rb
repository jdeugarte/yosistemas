class Grupo < ActiveRecord::Base
  	belongs_to :usuario
  	has_many :temas
  	has_many :subscriptions
  	has_many :tareas
  	validates :nombre, :presence => true

  	def usuario_suscrito?(id)
  		resp = true
  		for suscripcion in self.subscriptions
  			if suscripcion.usuario_id == id
  				return resp = false
  			end
  		end
  		return resp
  	end
end
