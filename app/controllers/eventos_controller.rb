require 'pusher'
class EventosController < ApplicationController
  before_action :set_evento, only: [:show, :edit, :update, :destroy]
  before_filter :grupos
  # GET /eventos
  def index
     @eventos = Array.new 
   if params[:grupo] != nil && Grupo.find(params[:grupo]).habilitado
        @grupo = Grupo.find(params[:grupo])       
      else
        @grupo = Grupo.find(1)
      end
       @grupo.eventos.each do |evento|
          if evento.aprobado?(@grupo.id) || @grupo.llave == "publico"
            @eventos << evento
          end
        end
  end


  # GET /eventos/1
  def show
   @evento = Evento.find(params[:id])
   @evento.grupos.each do |grupo|
    if current_user.esta_subscrito?(grupo.id)
      @grupo = grupo
      break
    end
    end
  end

  # GET /eventos/new
  def new
    @evento = Evento.new
    @grupo = Grupo.find(params[:id])
    @GrupoDefecto = @grupo
  end

  # GET /eventos/1/edit
  def edit
  end

  # POST /eventos
  def create
    @evento = Evento.new(evento_params)
    @evento.usuario_id = current_user.id
    
    if params[:grupos] != nil && @evento.save
        params[:grupos].each do |grupo|
          grupi = Grupo.find(grupo)
          grupi.eventos << @evento
          @evento.grupos_pertenece << grupo
           grupi.save
            if current_user.rol == "Docente" || !Grupo.find(grupo).moderacion
              @evento.grupos_dirigidos << grupo
            end
        end
        @evento.save


        if current_user.rol == "Docente"        
          notificacion_push(params[:grupos], @evento)
          notificar_por_email(params[:grupos], @evento)
        end

        grupos_para_notificar_si_moderacion_falsa = Array.new
        grupos_para_notificar_si_moderacion_verdadera = Array.new

        if current_user.rol == "Estudiante" 
          params[:grupos].each do |grupo_id|
            if Grupo.find(grupo_id).moderacion
              grupos_para_notificar_si_moderacion_verdadera << grupo_id
            else
              grupos_para_notificar_si_moderacion_falsa << grupo_id
            end        
            notificar_creacion(grupos_para_notificar_si_moderacion_verdadera, @evento)
            notificacion_push(grupos_para_notificar_si_moderacion_falsa, @evento)
            notificar_por_email(grupos_para_notificar_si_moderacion_falsa, @evento)
          end
        end
        flash[:notice] = "Evento creado Exitosamente! "
        redirect_to '/eventos/' + @evento.id.to_s
      else
        flash[:alert] = 'El evento no pudo ser creado!'
        redirect_to(:back)
    end
  end

  # PATCH/PUT /eventos/1
  def update
    respond_to do |format|
      if @evento.update(evento_params)
        format.html { redirect_to @evento, notice: 'Evento fue actualizado satisfactoriamente.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /eventos/1
  def destroy
    @evento.destroy
    flash[:alert] = 'Evento eliminado'
    respond_to do |format|
      format.html { redirect_to eventos_url }
    end
  end

  def aprove
    @evento = Evento.find(params[:id])
    params[:grupos].each do |grupo|
     @evento.grupos_dirigidos << grupo
    end

    @evento.save
    notificacion_push(@evento.grupos_pertenece, @evento)
    notificar_por_email(@evento.grupos_pertenece, @evento)
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evento
      @evento = Evento.find(params[:id])
    end

    def grupos
      @grupo = Grupo.find(1)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def evento_params
      params.require(:evento).permit(:nombre, :detalle, :lugar, :fecha, :estado,:hora, :grupo_id, :admitido)
    end

    def notificacion_push(id_grupos, evento)
      notificado = Hash.new
      notificado[current_user.id] = true
      suscripciones = Subscripcion.all
      id_grupos.each do |grupo|
        id_grupo = grupo.to_i
        suscripciones.each do |suscrito|
          if suscrito.grupo_id == id_grupo
            if notificado[suscrito.usuario_id] == nil
               notificado[suscrito.usuario_id] = true
              @usuario = suscrito.usuario
              if @usuario.push_event == true
                if @usuario != nil
                  @grupo = Grupo.find(id_grupo)
                  @notificacion = Notification.new
                  @notificacion.title = evento.nombre
                  @notificacion.description = evento.detalle
                  @notificacion.reference_date = evento.fecha
                  @notificacion.tipo = 2
                  @notificacion.de_usuario_id = current_user.id
                  @notificacion.para_usuario_id = @usuario.id
                  @notificacion.seen = false
                  @notificacion.id_item = evento.id
                  @notificacion.save
                  Pusher.url = "http://673a73008280ca569283:555e099ce1a2bfc840b9@api.pusherapp.com/apps/60344"
                  Pusher['notifications_channel'].trigger('notification_event', {
                    para_usuario: @notificacion.para_usuario_id
                  })
                end
              end
            end
          end
        end
      end
    end

    def notificar_creacion(id_grupos, evento)
      notificado = Hash.new  
      id_grupos.each do |grupo|
        id_grupo = grupo.to_i
        @grupo = Grupo.find(grupo)
        if Grupo.find(id_grupo).llave != "publico"
          @usuario = Usuario.find(@grupo.usuario_id)
            if notificado[@usuario.id] == nil
              notificado[@usuario.id] = true
              @notificacion = Notification.new
              @notificacion.title = evento.nombre
              @notificacion.description = evento.detalle
              @notificacion.reference_date = evento.fecha
              @notificacion.tipo = 2
              @notificacion.de_usuario_id = current_user.id
              @notificacion.para_usuario_id = @usuario.id
              @notificacion.seen = false
              @notificacion.id_item = evento.id
              @notificacion.save
              Pusher.url = "http://673a73008280ca569283:555e099ce1a2bfc840b9@api.pusherapp.com/apps/60344"
              Pusher['notifications_channel'].trigger('notification_event', {
              para_usuario: @notificacion.para_usuario_id
              })
              SendMail.notify_event_creation(@usuario,evento, @grupo).deliver
            end
        end 
      end
    end

    def notificar_por_email(id_grupos, evento)
      notificado = Hash.new  
      notificado[current_user.id] = true
      id_grupos.each do |grupo|
        id_grupo = grupo.to_i
        suscripciones = Subscripcion.all
        suscripciones.each do |suscrito|
          if suscrito.grupo_id == id_grupo
            if notificado[suscrito.usuario_id] == nil
              notificado[suscrito.usuario_id] = true
              @usuario = suscrito.usuario
              if @usuario.mailer_event == true
                if @usuario != nil
                  @grupo = Grupo.find(id_grupo)
                  SendMail.notify_users_event_create(@usuario, evento, @grupo).deliver
                end
              end
            end
          end
        end
      end
    end
end
