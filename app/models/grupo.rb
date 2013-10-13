class Grupo < ActiveRecord::Base
  	belongs_to :usuario
  	has_many :temas
  	validates :nombre, :presence => { :message => " es requerido" } 
end
