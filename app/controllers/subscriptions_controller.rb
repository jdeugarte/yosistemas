class SubscriptionsController < ApplicationController

	skip_before_filter :verify_authenticity_token

    def create
    	@grupo = Grupo.find(params[:grupo_id])
    	@subscription = @grupo.subscriptions.create(subscriptions_params)
    	@subscription.usuario_id = current_user.id
    	@subscription.save
    	redirect_to grupos_path
  	end

  	private 
	def subscriptions_params
		params.require(:subscription).permit(:llave)
	end
end
