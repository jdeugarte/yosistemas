class Tema < ActiveRecord::Base
  has_many :comments
  validates :titulo, :presence => true
end
