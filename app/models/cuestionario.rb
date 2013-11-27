class Cuestionario < ActiveRecord::Base
  belongs_to :grupo
  belongs_to :usuario
  has_many :preguntas, :dependent => :destroy
  accepts_nested_attributes_for :preguntas, :reject_if => lambda{ |a| a[:texto].blank? }, :allow_destroy => true
  scope :buscar_cuestionarios,lambda { |grupo| where("grupo_id = ?", grupo.id)}
end
