class SessionsController < ApplicationController
  skip_before_filter :require_log_in
  skip_before_filter :verify_authenticity_token  
  def new
  end
  
  def create
    usuario = Usuario.autenticar(params[:correo], params[:contrasenia])    
    if usuario
      session[:usuario_id] = usuario.id
      redirect_to :back, :notice => "Logged in!"
    else
      redirect_to :back, :notice => "Correo o Contrasenia Invalida!"
    end
  end

  def destroy
    session[:usuario_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end
