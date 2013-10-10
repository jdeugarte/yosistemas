class Grupo < ActiveRecord::Base
  	belongs_to :usuario
  	validates :nombre, :presence => { :message => " es requerido" } 
end
