class CommentsController < ApplicationController
	def create
    	@tema = Tema.find(params[:tema_id])
    	@comment = @tema.comments.create(comment_params)
    	@comment.usuario_id = current_user.id
    	@comment.save
    	redirect_to @tema
  	end

	private 
	def comment_params
		params.require(:comment).permit(:body)
	end
end
