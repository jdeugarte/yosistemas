class Tarea < ActiveRecord::Base
  belongs_to :usuario
  belongs_to :grupo

  has_many :archivo_adjuntos

  validates :titulo, :presence => { :message => " es requerido" }
  validates :descripcion, :presence => { :message => " es requerida" }
  validates :fecha_entrega, :presence => { :message => " es requerida" }
end
