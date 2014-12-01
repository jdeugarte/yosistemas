class SessionsController < ApplicationController
  skip_before_filter :require_log_in
  skip_before_filter :verify_authenticity_token
  def new
  end

  def create
    usuario = Usuario.autenticar(params[:correo], params[:contrasenia])
    if usuario
      session[:usuario_id] = usuario.id
      usuario.conectado=true
      usuario.save
      redirect_to "/", :notice => "Sesion iniciada correctamente!"
    else
      redirect_to :back, :notice => "Correo o Contrasenia Invalida!"
    end
  end

  def destroy
    usuario=Usuario.find(session[:usuario_id])
    usuario.conectado=false
    usuario.save
    session[:usuario_id] = nil
    redirect_to "/", :notice => "Logged out!"
  end

  def obtener_conectados
    usuario=Usuario.find(params[:usuario_id])
    usuario.conectado=true
    usuario.save
    render :layout => nil
  end

  def eliminar_conectado
    usuario=Usuario.find(params[:usuario_id])
    usuario.conectado=false
    usuario.save
    redirect_to :back
  end

end