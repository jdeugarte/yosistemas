class Usuario < ActiveRecord::Base  
require 'digest/md5'

	has_many :temas
	has_many :tema_comentarios	
	has_many :subscripcions
	has_many :tareas
	has_many :suscripcion_temas
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
	:presence  =>  { :message => " es requerido, no puede ser nulo" },
	:length => {
		:minimum => 6,
	},
	:confirmation => TRUE

	validates_format_of :correo,
	:presence => { :message => " es requerido" },
	:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
	:message    => 'no valido'

	validates :nombre_usuario,
	:presence  =>  { :message => " es requerido" },
	:uniqueness => { :message => " ya esta siendo utilizado" }		


	validates :correo,
	:uniqueness =>{
		:message=> " ya existente"
	}

	def self.autenticar(correo, contrasenia)
    	usuario = find_by_correo(correo)
    	if usuario && usuario.contrasenia == Digest::MD5.hexdigest(contrasenia) && usuario.activa==true
      	return usuario
    	end
    	usuario=find_by_nombre_usuario(correo)
    	if usuario && usuario.contrasenia == Digest::MD5.hexdigest(contrasenia) && usuario.activa==true
      	return usuario
      	else
      	return nil
    	end
    end
    
    def esta_subscrito?(grupo_id)
    	self.subscripcions.each do |subs|
    		if(subs.grupo_id==grupo_id.to_i)
    			return true
    		end
		end
		return false
    end



  	def encrypt_password  	
  		self.contrasenia = Digest::MD5.hexdigest(contrasenia) 		
  	end

  	after_create do
  		subscripcion = Subscripcion.new
        subscripcion.usuario = self
        subscripcion.grupo = Grupo.find_by_id(1)
        subscripcion.save
  	end

end
