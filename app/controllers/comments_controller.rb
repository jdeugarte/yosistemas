class CommentsController < ApplicationController
	
    skip_before_filter :verify_authenticity_token

    def create
    	@tema = Tema.find(params[:tema_id])
    	@comment = @tema.comments.create(comment_params)
    	@comment.usuario_id = current_user.id
    	@comment.save

        notify_users(params[:tema_id])
    	redirect_to @tema
  	end

    def notify_users(id_tema)
        @suscripciones = SuscripcionTema.find([id_tema])
        @suscripciones.each do |suscrito|
            @usuario = Usuario.find(suscrito.usuario_id)
            SendMail.notify_users_tema(@usuario).deliver
            flash[:alert] = 'Usuarios notificados'
            
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
