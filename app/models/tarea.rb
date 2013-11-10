class Tarea < ActiveRecord::Base
  belongs_to :usuario
  belongs_to :grupo
  has_many :archivo_adjuntos
  has_many :notificacion_grupos
  has_many :tarea_comentarios
  validates :titulo, :presence => { :message => " es requerido" }
  validates :descripcion, :presence => { :message => " es requerida" }
  validates :fecha_entrega, :presence => { :message => " es requerida" }
  validates :hora_entrega, :presence => { :message => " es requerida" }
  delegate :nombre_usuario, :to => :usuario, :prefix => true
  def self.buscar_tarea(id)
        tarea=nil
        begin
          tarea = Tarea.find(id)
          rescue ActiveRecord::RecordNotFound
        end
      return tarea
  end
end
