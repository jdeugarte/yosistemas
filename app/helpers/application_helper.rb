module ApplicationHelper
  	def avatar_tam_url(user,tam)
    	gravatar_id = Digest::MD5::hexdigest(user.correo).downcase
    	"http://gravatar.com/avatar/#{gravatar_id}.png?s=#{tam}&d=wavatar"
  	end

  	def notificaciones_nueva_tarea
	    @notificaciones_grupo = Array.new
	    if current_user!=nil
	      suscripciones = Subscripcion.where(:usuario_id=>current_user.id)
	      suscripciones.each do |suscripcion|
	        @notificaciones_grupo = NotificacionGrupo.where(:subscripcion_id=>suscripcion.id,:notificado=>false)
	      end
	    end
	    @notificaciones_grupo
  	end

  	def subscripciones_usuario()
  		subscrpciones = current_user.subscripcions.sort{|x,y| x.created_at <=> y.created_at}
  		if(!params[:search].nil?)
  			search = params[:search]
  			subscrpciones=subscrpciones.select{|subs| (/#{search}/i.match(subs.grupo.nombre) || subs.grupo.id==@grupo.id)}
  		end
  		subscrpciones
  	end

    def usuarios_conectados()
      Usuario.all
    end

    def todos_los_usuarios()
      array_nombres_de_usuario =Array.new
      Usuario.all.each do |usuario|
        array_nombres_de_usuario << usuario.nombre_usuario
      end
      array_nombres_de_usuario
    end
end