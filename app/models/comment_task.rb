class CommentTask < ActiveRecord::Base
  belongs_to :tarea
  belongs_to :usuario
  has_many :notificacion_grupos
  validates :body, :presence => true
end
