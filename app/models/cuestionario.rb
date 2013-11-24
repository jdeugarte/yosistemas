class Cuestionario < ActiveRecord::Base
  belongs_to :grupo
  belongs_to :usuario
  scope :buscar_cuestionarios,lambda { |grupo| where("grupo_id = ?", grupo.id)}
end
