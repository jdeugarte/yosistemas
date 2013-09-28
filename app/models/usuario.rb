class Usuario < ActiveRecord::Base  
require 'digest/md5'


	has_many :comments
	  has_many :usuarios
  	  accepts_nested_attributes_for :usuarios

  	before_create :encrypt_password

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
	},
	:confirmation => TRUE

	validates :contrasenia_de_confirmacion,
		:presence => TRUE

	validates :correo,
	:presence => TRUE,
	:uniqueness => TRUE
	
	def self.autenticar(correo, contrasenia)
    	usuario = find_by_correo(correo)
    	if usuario && usuario.contrasenia == Digest::MD5.hexdigest(contrasenia)
      	usuario
    	else
      	nil
    	end
  end


  	def encrypt_password  	
  		self.contrasenia = Digest::MD5.hexdigest(contrasenia) 		
  	end

end
