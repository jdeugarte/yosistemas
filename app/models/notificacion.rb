class Notificacion < ActiveRecord::Base
  belongs_to :comment
  belongs_to :suscripcion_tema
end
