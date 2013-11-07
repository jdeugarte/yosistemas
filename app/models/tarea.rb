class Tarea < ActiveRecord::Base
  belongs_to :usuario
  belongs_to :grupo

  has_many :archivo_adjuntos
  has_many :notificacion_grupos

  validates :titulo, :presence => { :message => " es requerido" }
  validates :descripcion, :presence => { :message => " es requerida" }
  validates :fecha_entrega, :presence => { :message => " es requerida" }
  validates :hora_entrega, :presence => { :message => " es requerida" }
  
  delegate :nombre_usuario, :to => :usuario, :prefix => true
end
