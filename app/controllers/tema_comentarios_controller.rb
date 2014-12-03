require 'pusher'
class TemaComentariosController < ApplicationController	
    skip_before_filter :verify_authenticity_token
    def create
    	@tema = Tema.find(params[:tema_id])
    	@comentario = @tema.tema_comentarios.create(comentario_params)
    	@comentario.usuario_id = current_user.id
    	@comentario.save
        add_attached_files(@comentario.id)
        notify_users(@tema.id,@comentario)
        redirect_to @tema
  	end

    private
    def add_attached_files(tema_comentario_id)
      if(!params[:tema_comentario][:archivo].nil?)
        params[:tema_comentario][:archivo].each do |arch|
        @archivo = AdjuntoTemaComentario.new(:archivo=>arch)
        @archivo.tema_comentario_id = tema_comentario_id
        @archivo.save
        end
      end
    end

    def eliminar_archivos_adjuntos(idsParaBorrar)
        if (!idsParaBorrar.nil?)
          idsParaBorrar.slice!(0)
           idsParaBorrar=idsParaBorrar.split("-")
           idsParaBorrar.each do |id|
               AdjuntoTemaComentario.destroy(id)
           end
        end
    end

    public

    def notify_users(id_tema,comentario)
        @comentario = comentario
        suscripciones = SuscripcionTema.all
        suscripciones.each do |suscrito|
            if suscrito.tema_id == id_tema
                if suscrito.usuario_id != current_user.id
                    @usuario = Usuario.find(suscrito.usuario_id)
                    @tema = Tema.find(id_tema)
                    @tema.grupos.each do |grupo|
                        @notificacion = Notification.new
                        @notificacion.title = @tema.titulo
                        @notificacion.description = @comentario.cuerpo
                        @notificacion.reference_date = nil
                        @notificacion.tipo = 4
                        @notificacion.de_usuario_id = current_user.id
                        @notificacion.para_usuario_id = @usuario.id
                        @notificacion.seen = false
                        @notificacion.id_item = @comentario.id
                        @notificacion.save
                        Pusher.url = "http://673a73008280ca569283:555e099ce1a2bfc840b9@api.pusherapp.com/apps/60344"
                        Pusher['notifications_channel'].trigger('notification_event', {
                        para_usuario: @notificacion.para_usuario_id
                        })
                        #SendMail.notify_users_tema(@usuario, @tema, grupo).deliver
                    end   
                end
            end
        end
    end
    
    def delete
        @comentario = TemaComentario.find(params[:id])
        @tema = @comentario.tema
        @comentario.destroy
        redirect_to @tema
    end

    def editar
        comentario = TemaComentario.find(params[:id])
        comentario.update(params[:tema_comentario].permit(:cuerpo))
        eliminar_archivos_adjuntos(params[:elemsParaElim])
        add_attached_files(comentario.id)
        comentario.save
        redirect_to "/temas/"+comentario.tema_id.to_s
    end

	private
	def comentario_params
		params.require(:tema_comentario).permit(:cuerpo)
	end
end