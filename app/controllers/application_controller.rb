class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :current_user
  before_filter :require_log_in  
  helper_method :notifications
  private
  
  def current_user
    @current_user ||= Usuario.find(session[:usuario_id]) if session[:usuario_id]    
  end
  
  def require_log_in
    unless current_user
      redirect_to log_in_path
    end
  end

  def notifications
    @notifications = Array.new
    if current_user!=nil
      suscripciones = SuscripcionTema.where(:usuario_id=>current_user.id)
      suscripciones.each do |suscripcion| 
        notificaciones = Notificacion.where(:suscripcion_temas_id=>suscripcion.id,:notificado=>false)
        so=""
        notificaciones.each do |notificacion|
          @notifications.push (notificacion)
          #notificacion.notificado = true
          #notificacion.save    
          so=so+"b"
          flash[:alert]="s"+so
        end
      end
    end
    @notifications
  end


end
