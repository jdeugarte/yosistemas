class SessionsController < ApplicationController
  skip_before_filter :require_log_in
  skip_before_filter :verify_authenticity_token  
  def new
  end
  
  def create
    usuario = Usuario.autenticar(params[:correo], params[:contrasenia])    
    if usuario
      session[:usuario_id] = usuario.id
      if (request.referrer.include? "/usuarios") || (request.referrer.include? "usuarios/confirm" ) || (request.referrer.include? "/send_password_mail")        
       
        if notifications == nil || notifications.size < 1
         redirect_to root_url, :notice => "Logged in!"
        else
          if notifications.size == 1
            redirect_to root_url, :notice => "Logged in!  .  .  .  .  .  .  .  .  .  .  Usted tiene "+notifications.size.to_s+" notificacion"   
          else
            redirect_to root_url, :notice => "Logged in!  .  .  .  .  .  .  .  .  .  .  Usted tiene "+notifications.size.to_s+" notificaciones"   
          end
        end
      else

        if notifications == nil || notifications.size < 1
         redirect_to :back, :notice => "Logged in!"
        else
          if notifications.size == 1
            redirect_to :back, :notice => "Logged in!  .  .  .  .  .  .  .  .  .  .  Usted tiene "+notifications.size.to_s+" notificacion"   
          else
            redirect_to :back, :notice => "Logged in!  .  .  .  .  .  .  .  .  .  .  Usted tiene "+notifications.size.to_s+" notificaciones"   
          end
        end
      end
    else
        
      redirect_to :back, :notice => "Correo o Contrasenia Invalida!"      
    end
  end

  
  def destroy
    notifications.each do |notificacion|
      notificacion.notificado = true
      notificacion.save 
    end
    session[:usuario_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end
