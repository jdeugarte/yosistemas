class Grupo < ActiveRecord::Base
  	belongs_to :usuario
  	has_many :temas
  	has_many :subscripcions
  	has_many :tareas
    has_many :cuestionarios
    has_many :eventos
  	validates :nombre, :presence => true
    delegate :nombre_usuario, :to => :usuario, :prefix => true
  	scope :buscar_mis_grupos,lambda { |user| where("usuario_id = ?", user.id)}

    def usuario_suscrito?(id)
  		resp = true
  		for suscripcion in self.subscripcions
  			if suscripcion.usuario_id == id
  				return resp = false
  			end
  		end
  		return resp
  	end

    def correspondeAGrupo(nombre)
      parametros = nombre.split(' ')
      parametros.each do |parametro|
         if self.nombre.downcase.include?(parametro.downcase)
           return true
         end
      end
      false
    end
end
