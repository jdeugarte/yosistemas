class Tema < ActiveRecord::Base
  validates :titulo, :presence => true
  validates :contenido, :uniqueness => true, :presence => true
end
