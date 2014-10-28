require 'pusher'
class EventosController < ApplicationController
  before_action :set_evento, only: [:show, :edit, :update, :destroy]
  before_filter :grupos
  # GET /eventos
  def index
    @eventos = Evento.all.page(params[:page]).per(5)
  end

  # GET /eventos/1
  def show
    @evento = Evento.find(params[:id])
  end

  # GET /eventos/new
  def new
    @evento = Evento.new
  end

  # GET /eventos/1/edit
  def edit
  end

  # POST /eventos
  def create
    @evento = Evento.new(evento_params)
    @evento.usuario_id = current_user.id
    respond_to do |format|
      if @evento.save
        notificacion_push(@evento.grupo_id, @evento)
        format.html { redirect_to @evento, notice: 'Evento ha sido creado.' }
      else
        format.html { render action: 'Nuevo' }
        
      end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evento
      @evento = Evento.find(params[:id])
    end

    def grupos
      if(params[:id] != nil && Grupo.find(params[:id]).habilitado)
       @grupo = Grupo.find(params[:id])
     else
       @grupo = Grupo.find(1)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def evento_params
      params.require(:evento).permit(:nombre, :detalle, :lugar, :fecha, :estado,:hora, :grupo_id)
    end
    def notificacion_push(id_grupo, evento)
      suscripciones = Subscripcion.all
      suscripciones.each do |suscrito|
        if suscrito.grupo_id == id_grupo
          if suscrito.usuario_id != current_user.id
            @usuario = suscrito.usuario
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

              Pusher.url = "http://5ea0579076700b536e21:503a6ba2bb803aa4ae5c@api.pusherapp.com/apps/60344"
              Pusher['notifications_channel'].trigger('notification_event', {
                para_usuario: @notificacion.para_usuario_id
              })
            end
          end
        end
      end
    end
end
