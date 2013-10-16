class Notificacion < ActiveRecord::Base
  has_many :comments
  has_many :suscripcion_temas
end
