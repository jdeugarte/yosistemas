class TareaComentariosController < ApplicationController
  def create
    @tarea = Tarea.find(params[:tarea_id])
    @comentario = @tarea.tarea_comentarios.create(comentario_params)
    @comentario.usuario_id = current_user.id
    @comentario.save
    redirect_to @tarea
  end
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def comentario_params
      params.require(:tarea_comentario).permit(:cuerpo)
    end
end
