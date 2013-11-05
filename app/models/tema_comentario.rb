class TemaComentario < ActiveRecord::Base
  belongs_to :tema
  belongs_to :usuario
  has_many :notificacions
  has_many :archivo_adjunto_comentario
  validates :cuerpo, :presence => true 
end
