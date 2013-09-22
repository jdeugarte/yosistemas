class Usuario < ActiveRecord::Base
	  has_many :usuarios
  	  accepts_nested_attributes_for :usuarios
	validates :nombre,
	:presence  => TRUE,
	:length => {
		:minimum => 2,
		:allow_blank => TRUE
	}
	validates :apellido,
	:presence  => TRUE,
	:length => {
		:minimum => 2,
		:allow_blank => TRUE
	}
	validates :contrasenia,
	:presence  => TRUE,
	:length => {
		:minimum => 6,
		:allow_blank => TRUE
	}
	validates :correo,
	:presence => TRUE,
	:uniqueness => TRUE

end
