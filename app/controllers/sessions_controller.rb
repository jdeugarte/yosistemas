class SessionsController < ApplicationController
  skip_before_filter :require_log_in
  skip_before_filter :verify_authenticity_token  
  def new
  end
  
  def create
    usuario = Usuario.autenticar(params[:correo], params[:contrasenia])    
    if usuario
      session[:usuario_id] = usuario.id
      @cont = check_notifications(usuario)
      if (request.referrer.include? "/usuarios/new") || (request.referrer.include? "usuarios/confirm?pass" ) || (request.referrer.include? "/send_password_mail")        

        redirect_to root_url, :notice => "Logged in!  "+@cont.to_s+"  notifications: "
      else
        redirect_to :back, :notice => "Logged in!  "+@cont.to_s+"  notifications: "
      end
    else
        
      redirect_to :back, :notice => "Correo o Contrasenia Invalida!"      
    end
  end

  def check_notifications(user)
    @var = 0
    @suscripciones = SuscripcionTema.where(usuario_id: user.id)
    @suscripciones.each do |suscripcion|
      @notificaciones = Notificacion.where(suscripcion_temas_id: suscripcion.id , notificado: false)
      @notificaciones.each do |notificacion|
        if notificacion.notificado==false
          @var = @var+1
          notificacion.notificado=true
          notificacion.save
        end
      end
    end
    return @var
  end


  def destroy
    session[:usuario_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end
