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
                @tema=Tema.find(id_tema)
                @grupo=Grupo.find(@tema.grupo_id)
                @notificacion = Notificacion.new
                @notificacion.notificado = false
                @notificacion.suscripcion_tema_id = suscrito.id
                @notificacion.tema_comentario_id = @comentario.id
                @notificacion.save
                SendMail.notify_users_tema(@usuario, @tema, @grupo).deliver
            end
            end
        end
    end

    def delete
        @comentario = TemaComentario.find(params[:id])
        @tema = @comentario.tema
        if(@comentario.usuario.correo == current_user.correo)
            @comentario.destroy
        end
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