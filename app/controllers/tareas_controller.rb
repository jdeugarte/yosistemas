class TareasController < ApplicationController
  #GET tareas/new	
  def new
  	@tarea = Tarea.new
    @grupos = Array.new
    if(current_user!=nil)
      current_user.subscriptions.each do |subs|
        @grupos.push(subs.grupo)
      end
      @grupo = Grupo.find(params[:id])
    end
  end
  #POST tareas/create
  def create
    @tarea = Tarea.new(tarea_params)
    @tarea.grupo_id=params[:tema][:grupo_id]
    @tarea.usuario_id = current_user.id 
    @tarea.save
    redirect_to temas_url 
  end

  private
    # No permite parametros de internet
    def tarea_params
      params.require(:tarea).permit(:titulo, :descripcion, :fecha_entrega)
    end

end
