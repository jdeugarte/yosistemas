class TareasController < ApplicationController
  #GET tareas/new	

  def responder_tarea
    @responder_tarea = ResponderTarea.new
    @tarea = Tarea.find(params[:id])
    @grupo = @tarea.grupo
    @grupos = Array.new
    if(current_user!=nil)
      current_user.subscriptions.each do |subs|
        @grupos.push(subs.grupo)
      end
    end
    @usuarios = Subscription.where(:usuario_id => current_user.id,:id => @grupo.id)
    if(@usuarios.nil?)
      redirect_to root_path
    end

  end

  def responder_tarea_crear
    @responder_tarea = ResponderTarea.new(params[:t])
    @tarea = Tarea.find(params[:id])
    @responder_tarea.tarea_id = @tarea.id
    @responder_tarea.usuario_id = current_user.id 
    if(@responder_tarea.save)
      add_attached_files_respuesta(@responder_tarea.id)
      flash[:alert] = 'Tarea enviada Exitosamente!'
      redirect_to '/grupos/'+@tarea.grupo.id+'/temas' 
    else
      # @grupos = Array.new
      #if(current_user!=nil)
      #current_user.subscriptions.each do |subs|
      #  @grupos.push(subs.grupo)
      #  end
      #  @grupo = Grupo.find(params[:responder_tarea][:grupo_id])
      #  @id = params[:responder_tarea][:grupo_id]
      #end
      #render :new;

      @responder_tarea.errors.each do |err|
         flash[:alert] = err
      end
      redirect_to root_path
    end
  end

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

    def add_attached_files_respuesta(responder_tarea_id)
      if(!params[:responder_tarea][:archivo].nil?)
        params[:responder_tarea][:archivo].each do |arch|
        @archivo = ArchivoAdjuntoRespuestas.new(:archivo=>arch)
        @archivo.responder_tarea_id = responder_tarea_id 
        @archivo.save
        end
      end

    end


end
