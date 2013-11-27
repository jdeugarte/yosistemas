class Pregunta < ActiveRecord::Base
  belongs_to :cuestionario
  has_many :respuestas
  accepts_nested_attributes_for :respuestas, :reject_if => lambda{ |a| a[:texto].blank? }, :allow_destroy => true
end
