class ResponderTarea < ActiveRecord::Base
  belongs_to :usuario
  belongs_to :grupo
  belongs_to :tarea
  has_many :archivo_adjunto_respuestas
  validates :descripcion, :presence => {:message => " es requerida"}
end
