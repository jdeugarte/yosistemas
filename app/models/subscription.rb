class Subscription < ActiveRecord::Base
  belongs_to :usuario
  belongs_to :grupo
  has_many :notificacion_grupos
end
