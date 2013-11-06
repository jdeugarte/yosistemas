class SubscripcionsController < ApplicationController

	skip_before_filter :verify_authenticity_token

    def create
    	@grupo = Grupo.find(params[:grupo_id])
    	@subscripcion = @grupo.subscripcions.create(subscripcions_params)

      if verificar_llave(@subscripcion.llave, @grupo.llave)
    	   @subscripcion.usuario_id = current_user.id
    	   @subscripcion.save
         SendMail.notify_users_grupo(current_user, @grupo.nombre).deliver #con sto envio el correo
    	   redirect_to grupos_path, :flash => { :info => "Suscrito exitosamente" }
      else
         @subscripcion.destroy
         redirect_to suscribirse_path(@grupo), :flash => { :error => "Error al ingresar la llave" }
      end
  	end

    def delete
        @suscripcion = Subscription.find(params[:id])
        @grupo = @suscripcion.grupo
        @suscripcion.destroy
        redirect_to suscriptores_path(@grupo)
    end

private 

	def subscripcions_params
		params.require(:subscripcion).permit(:llave)
	end

  def verificar_llave(llave_suscripcion, llave_grupo)
    return llave_suscripcion == llave_grupo
  end
end
