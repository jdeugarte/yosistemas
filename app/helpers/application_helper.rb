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
end