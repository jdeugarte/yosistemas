class SessionsController < ApplicationController
  skip_before_filter :require_log_in
  
  def new
  end
  
  def create
    usuario = Usuario.autenticar(params[:correo], params[:contrasenia])    
    if usuario
      session[:usuario_id] = usuario.id
      redirect_to temas_path, :notice => "Logged in!"
    else
      flash.now.alert = "Correo o Contrasenia Invalida! "
      render "new"
    end
  end

  def destroy
    session[:usuario_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end
