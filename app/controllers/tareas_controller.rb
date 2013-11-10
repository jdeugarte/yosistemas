class TareasController < ApplicationController

  #GET tareas
  def index
    if(params[:grupo]!="1" && current_user.esta_subscrito?((params[:grupo])))
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
        @id=@grupo.id
        enviado=ResponderTarea.where(:usuario_id => current_user.id,:tarea_id => @tarea.id)
        @suscrito = Subscripcion.where(:grupo_id => @grupo.id, :usuario_id => current_user.id)
        if(!@suscrito.first.nil? && enviado.first.nil?)
          @grupos = Array.new
          if(current_user!=nil)
            current_user.subscripcions.each do |subs|
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

  def mostrar_respuesta_tarea
    @respuesta_tarea=ResponderTarea.find(params[:id])
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
      current_user.subscripcions.each do |subs|
        @grupos.push(subs.grupo)
        end
        @grupo = Grupo.find(@tarea.grupo.id.to_s)
        @id = @tarea.grupo.id.to_s
      end
      render :responder_tarea;
    end
  end

  def new
    if(params[:id]!="1" && Grupo.find(params[:id]).usuario==current_user)
    	@tarea = Tarea.new
      @grupos = Array.new
      if(current_user!=nil)
        current_user.subscripcions.each do |subs|
          @grupos.push(subs.grupo)
        end
        @grupo = Grupo.find(params[:id])
        @id = params[:id]
      end
    else
      redirect_to tareas_path
    end
  end

  def eliminar
      @tarea = Tarea.find(params[:id])
      @grupo = @tarea.grupo
      if(@tarea.usuario_id == current_user.id)
        @tarea.destroy
        flash[:alert] = 'Tarea eliminada'
      end

      redirect_to '/grupos/'+@grupo.id.to_s+'/tareas'
    end

  def show
    @tarea = Tarea.find(params[:id])
    @todos_los_comentarios = @tarea.tarea_comentarios.reverse
    if(current_user==@tarea.usuario)
        @tareas_enviadas=ResponderTarea.where(:tarea_id => @tarea.id)
    end
    if(!current_user.esta_subscrito?(@tarea.grupo.id))
      redirect_to temas_path
    else
      @enviado=ResponderTarea.where(:usuario_id => current_user.id,:tarea_id => @tarea.id).first.nil?
      suscripcion=Subscripcion.where(:usuario_id=>current_user.id, :grupo_id=>@tarea.grupo.id)
      suscripcion.first.notificacion_grupos.where(:notificado=>false).each do |notificacion|
        if notificacion.tarea_id.to_s==params[:id].to_s
          notificacion.notificado=true
          notificacion.save
        end
      end
    end
  end
  def edit #id tarea
    if(params[:id]!="1")
      @tarea = Tarea.find(params[:id])
      @grupos = Array.new
      if(current_user!=nil)
        current_user.subscripcions.each do |subs|
          @grupos.push(subs.grupo)
        end
        @grupo = Grupo.find(@tarea.grupo_id)
        @id = params[:id]
      end
    else
      redirect_to temas_path
    end
  end
  def update
    @tarea = Tarea.find(params[:id])
    if(@tarea.update(params[:tarea].permit(:titulo,:descripcion,:fecha_entrega,:grupo_id,:hora_entrega)))
      redirect_to @tarea
    else
      render 'edit'
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
      notify_users(@tarea.grupo_id, @tarea)
      redirect_to '/grupos/'+params[:tarea][:grupo_id]+'/tareas'
    else
       @grupos = Array.new
      if(current_user!=nil)
      current_user.subscripcions.each do |subs|
        @grupos.push(subs.grupo)
        end
        @grupo = Grupo.find(params[:tarea][:grupo_id])
        @id = params[:tarea][:grupo_id]
      end
      render :new;
    end
  end

  def editar_comentario
    @comentario=TareaComentario.find(params[:id_comentario])
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
        @archivo = ArchivoAdjuntoRespuesta.new(:archivo=>arch)
        @archivo.responder_tarea_id = responder_tarea_id
        @archivo.save
        end
      end
    end

    def notify_users(id_grupo,tarea)
        suscripciones = Subscripcion.all
        suscripciones.each do |suscrito|
          if suscrito.grupo_id == id_grupo
            if suscrito.usuario_id != current_user.id
                @usuario = suscrito.usuario
                @grupo=Grupo.find(id_grupo)
                @notificacion = NotificacionGrupo.new
                @notificacion.notificado = false
                @notificacion.subscripcion_id = suscrito.id
                @notificacion.tarea = tarea
                @notificacion.save
                SendMail.notify_users_task_create(@usuario, tarea, @grupo).deliver
            end
          end
        end
    end
end
