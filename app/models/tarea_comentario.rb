class TareaComentario < ActiveRecord::Base
  belongs_to :tarea
  belongs_to :usuario
  validates :cuerpo, :presence => true
end
