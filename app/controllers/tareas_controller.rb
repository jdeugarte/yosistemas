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
      @id = params[:id]
    end
  end
  #POST tareas/create
  def create
    @tarea = Tarea.new(tarea_params)
    @tarea.grupo_id=params[:tarea][:grupo_id]
    @tarea.usuario_id = current_user.id 
    if(@tarea.save)
      add_attached_files(@tarea.id)
      flash[:alert] = 'Tarea creada Exitosamente!'
      redirect_to '/grupos/'+params[:tarea][:grupo_id]+'/temas' 
    else
       @grupos = Array.new
      if(current_user!=nil)
      current_user.subscriptions.each do |subs|
        @grupos.push(subs.grupo)
        end
        @grupo = Grupo.find(params[:tarea][:grupo_id])
        @id = params[:tarea][:grupo_id]
      end
      render :new;
    end
  end

  private
    # No permite parametros de internet
    def tarea_params
      params.require(:tarea).permit(:titulo, :descripcion, :fecha_entrega, :hora_entrega)
    end

    def add_attached_files(tarea_id)
      if(!params[:tarea][:archivo].nil?)
        params[:tarea][:archivo].each do |arch|
        @archivo = ArchivoAdjunto.new(:archivo=>arch)
        @archivo.tarea_id = tarea_id 
        @archivo.save
        end
      end

    end

end
