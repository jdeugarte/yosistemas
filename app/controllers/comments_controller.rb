class CommentsController < ApplicationController
	
    skip_before_filter :verify_authenticity_token

    def create
    	@tema = Tema.find(params[:tema_id])
    	@comment = @tema.comments.create(comment_params)
    	@comment.usuario_id = current_user.id
    	@comment.save
        notify_users(@tema.id,@comment)
        redirect_to @tema
  	end

    def notify_users(id_tema,comment)

        @commentt = comment
        suscripciones = SuscripcionTema.all
        suscripciones.each do |suscrito|
           if suscrito.tema_id == id_tema 
            if suscrito.usuario_id != current_user.id
                @usuario = Usuario.find(suscrito.usuario_id)
                @tema=Tema.find(id_tema)
                @grupo=Grupo.find(@tema.grupo_id)
                @notificacion = Notificacion.new
                @notificacion.notificado = false
                @notificacion.suscripcion_temas_id = suscrito.id
                @notificacion.comments_id = @commentt.id
                @notificacion.save    
                SendMail.notify_users_tema(@usuario, @tema, @grupo).deliver    
            end
            end 
        end
    end

    def delete
        @comment = Comment.find(params[:id])
        @tema = @comment.tema
        if(@comment.usuario.correo == current_user.correo)
            @comment.destroy
        end
        redirect_to @tema
    end

    def editc
        comment = Comment.find(params[:id])
        comment.body = params[:body]
        comment.save
        redirect_to "/temas/"+comment.tema_id.to_s
    end

	private 
	def comment_params
		params.require(:comment).permit(:body)
	end
end
