class Evento < ActiveRecord::Base
	serialize :grupos_pertenece, Array
	belongs_to :usuario
	belongs_to :grupo
end
