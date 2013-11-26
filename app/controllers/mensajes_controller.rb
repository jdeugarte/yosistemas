class MensajesController < ApplicationController  
	skip_before_filter :verify_authenticity_token
  def enviar
  	para=Usuario.find_by_nombre_usuario(params[:para].to_s)
  	if (para)
	  	mensaje=Mensaje.create('de_usuario'=> current_user, 'para_usuario'=>para, 'mensaje' => params[:mensaje].to_s)
	  	if(mensaje)
	  		flash[:alert]="Mensaje enviado!"
	  	else
	  		flash[:alert]="Error al enviar el mensaje!"
	  	end
	else
		flash[:alert]="Error al enviar el mensaje usuario incorrecto!"
	end
  	redirect_to :back
  end
end