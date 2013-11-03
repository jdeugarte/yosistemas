class ResponderTarea < ActiveRecord::Base
  belongs_to :usuario
  belongs_to :grupo
  belong_to :tarea
  has_many :archivo_adjuntos_respuesta
	validates :descripcion, :presence => { :message => " es requerida" }
end
