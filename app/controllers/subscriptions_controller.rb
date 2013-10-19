class SubscriptionsController < ApplicationController

	skip_before_filter :verify_authenticity_token

    def create
    	@grupo = Grupo.find(params[:grupo_id])
    	@subscription = @grupo.subscriptions.create(subscriptions_params)

      if verificar_llave(@subscription.llave, @grupo.llave)
    	   @subscription.usuario_id = current_user.id
    	   @subscription.save
         SendMail.notify_users_grupo(current_user, @grupo.nombre).deliver #con sto envio el correo
    	   redirect_to grupos_path, :flash => { :info => "Suscrito exitosamente" }
      else
         @subscription.destroy
         redirect_to suscribirse_path(@grupo), :flash => { :error => "Error al ingresar la llave" }
      end
  	end

private 

	def subscriptions_params
		params.require(:subscription).permit(:llave)
	end

  def verificar_llave(llave_suscripcion, llave_grupo)
    return llave_suscripcion == llave_grupo
  end
end
