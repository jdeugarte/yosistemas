class SuscripcionTemasController < ApplicationController
  def new
  	@suscripcion = SuscripcionTema.new
  end
  def create

	    @suscripcion = SuscripcionTema.new
	    @suscripcion.usuario_id=current_user.id
	    @suscripcion.tema_id =params[:id]
	    @suscripcion.save
	    redirect_to temas_url 
  end
end
