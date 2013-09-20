class Tema < ActiveRecord::Base
	validates :titulo, :presence => true
end
