class Usuario < ActiveRecord::Base  
require 'digest/md5'

	has_many :temas
	has_many :comments
	has_many :subscriptions
	  has_many :usuarios
  	  accepts_nested_attributes_for :usuarios

  	before_create :encrypt_password



	validates :nombre,
	:presence  => { :message => " es requerido, no puede ser nulo" },
	:length => {
		:minimum => 2,
		:allow_blank => TRUE
	}
	validates :apellido,
	:presence  => { :message => " es requerido, no puede ser nulo" },
	:length => {
		:minimum => 2,
		:allow_blank => TRUE
	}
	validates :contrasenia,
	:presence  => TRUE,
	:length => {
		:minimum => 6,
	},
	:confirmation => TRUE

	validates_format_of :correo,
	:presence => { :message => " es requerido" },
	:uniqueness => TRUE,
	:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
	:message    => 'no valido'

	
	def self.autenticar(correo, contrasenia)
    	usuario = find_by_correo(correo)
    	if usuario && usuario.contrasenia == Digest::MD5.hexdigest(contrasenia) && usuario.activa==true
      	usuario
    	else
      	nil
    	end
  end


  	def encrypt_password  	
  		self.contrasenia = Digest::MD5.hexdigest(contrasenia) 		
  	end

end
