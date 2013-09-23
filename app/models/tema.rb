class Tema < ActiveRecord::Base
  validates :titulo, :presence => true
  validates :contenido. presence => true
end
