class Grupo < ActiveRecord::Base
  	belongs_to :usuario
  	has_many :temas
  	has_many :subscriptions
  	has_many :tareas
  	validates :nombre, :presence => { :message => " es requerido" } 
end
