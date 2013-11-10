class TareaComentariosController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def create
    @tarea = Tarea.find(params[:tarea_id])
    @comentario = @tarea.tarea_comentarios.create(comentario_params)
    @comentario.usuario_id = current_user.id
    @comentario.save
    redirect_to @tarea
  end
  def editar
        @comentario = TareaComentario.find(params[:id])
        @comentario.update(:cuerpo=>params[:cuerpo])
        redirect_to @comentario.tarea
   end
   def delete
        @comentario = TareaComentario.find(params[:id])
        if(@comentario.usuario.correo == current_user.correo)
            @comentario.destroy
        end
        redirect_to @comentario.tarea
    end
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def comentario_params
      params.require(:tarea_comentario).permit(:cuerpo)
    end
end
