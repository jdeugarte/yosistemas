require 'pusher'
class EventosController < ApplicationController
  before_action :set_evento, only: [:show, :edit, :update, :destroy]
  before_filter :grupos
  # GET /eventos
  def index
    @eventos = Array.new
    current_user.misgrupos.each do |grupo|
      Grupo.find(grupo).eventos.each do |evento|
        if evento.admitido == true
          @eventos << evento  
        end
      end
    end
    Grupo.find(1).eventos.each do |evento|
       @eventos << evento
    end
    @eventos = @eventos.uniq
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
  end

  # GET /eventos/1/edit
  def edit
  end

  # POST /eventos
  def create
    @evento = Evento.new(evento_params)
    @evento.usuario_id = current_user.id
    
    if current_user.rol == "Docente"
      @evento.admitido = true
    else
      @evento.admitido = false
    end

    if params[:grupos] != nil && @evento.save
        params[:grupos].each do |grupo|
          grupi = Grupo.find(grupo)
          grupi.eventos << @evento
          @evento.grupos_pertenece << grupo
          grupi.save
        end

        if @evento.admitido = true
          notificacion_push(params[:grupos], @evento)
          notificar_por_email(params[:grupos], @evento)
        end
          
        if current_user.rol == "Estudiante"            
          notificar_creacion(params[:grupos], @evento)
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
    @evento.admitido = true
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
      notificado[current_user.id] = true
      id_grupos.each do |grupo|
        id_grupo = grupo.to_i
        @grupo = Grupo.find(grupo)
        @usuario = Usuario.find(@grupo.usuario_id)
        SendMail.notify_theme_creation(@usuario, evento, @grupo).deliver
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
