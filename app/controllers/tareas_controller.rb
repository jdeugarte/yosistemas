class TareasController < ApplicationController

  #GET tareas
  def index
    if(params[:grupo]!="1")
      @tareas = Tarea.where(:grupo_id => params[:grupo]).reverse
      @grupo = Grupo.find(params[:grupo])
    else
      redirect_to temas_path
    end
  end

  #GET tareas/new	
  def responder_tarea
    if(current_user.rol == "Estudiante" )

      @responder_tarea = ResponderTarea.new
      
      begin
        @tarea = Tarea.find(params[:id])
        rescue ActiveRecord::RecordNotFound
        redirect_to root_path
      end
      if(!@tarea.nil?)

        @grupo = @tarea.grupo
        @suscrito = Subscription.where(:grupo_id => @grupo.id, :usuario_id => current_user.id)
        if(!@suscrito.first.nil?)

          @grupos = Array.new
          if(current_user!=nil)
            current_user.subscriptions.each do |subs|
              @grupos.push(subs.grupo)

            end
          end
        else
          redirect_to root_path
        end
      end
    else
      redirect_to root_path
    end

  end

  def responder_tarea_crear
    @responder_tarea = ResponderTarea.new(tarea_respuesta_params)
    @tarea = Tarea.find(params[:id])
    @responder_tarea.tarea_id = @tarea.id
    @responder_tarea.usuario_id = current_user.id
    if(@responder_tarea.save)
      add_attached_files_respuesta(@responder_tarea.id)
      flash[:alert] = 'Tarea enviada Exitosamente!'
      redirect_to '/grupos/'+@tarea.grupo.id.to_s+'/temas' 
    else
      @grupos = Array.new
      if(current_user!=nil)
      current_user.subscriptions.each do |subs|
        @grupos.push(subs.grupo)
        end
        @grupo = Grupo.find(@tarea.grupo.id.to_s)
        @id = @tarea.grupo.id.to_s
      end
      render :responder_tarea;
    end
  end

  def new
    if(params[:id]!="1")
    	@tarea = Tarea.new
      @grupos = Array.new
      if(current_user!=nil)
        current_user.subscriptions.each do |subs|
          @grupos.push(subs.grupo)
        end
        @grupo = Grupo.find(params[:id])
        @id = params[:id]
      end
    else
      redirect_to temas_path
    end
  end

  def show
    @tarea = Tarea.find(params[:id])  
  end
  #POST tareas/create
  def create
    @tarea = Tarea.new(tarea_params)
    @tarea.grupo_id=params[:tarea][:grupo_id]
    @tarea.usuario_id = current_user.id 
    if(@tarea.save)
      add_attached_files(@tarea.id)
      flash[:alert] = 'Tarea creada Exitosamente!'
      notify_users(@tarea.grupo_id, @tarea)
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

    def tarea_respuesta_params
      params.require(:responder_tarea).permit(:descripcion)
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

    def notify_users(id_grupo,tarea)
        
        suscripciones = Subscription.all
        suscripciones.each do |suscrito|
          if suscrito.grupo_id == id_grupo 
            if suscrito.usuario_id != current_user.id
                @usuario = suscrito.usuario
                @grupo=Grupo.find(id_grupo)


                @notificacion = NotificacionGrupo.new
                @notificacion.notificado = false
                @notificacion.subscription_id = suscrito.id
                @notificacion.tarea = tarea
                @notificacion.save    
                SendMail.notify_users_task_create(@usuario, tarea, @grupo).deliver    
            end
          end 
        end
    end

    def eliminar
      @tarea = Tarea.find(params[:id])
      @grupo = @tarea.grupo
      if(@tarea.usuario_id == current_user.id)
        @tarea.destroy
      end
      redirect_to @grupo
    end


end
