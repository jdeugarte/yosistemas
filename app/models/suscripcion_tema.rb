class SuscripcionTema < ActiveRecord::Base
  belongs_to :tema
  belongs_to :usuario
  belongs_to :notificacion
end
