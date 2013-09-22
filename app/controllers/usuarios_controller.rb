class UsuariosController < ApplicationController
  def index
  end

  def show
  end

  def new
  	@usuario = Usuario.new
  end

  def create
  	  params.permit!
  		@usuario = Usuario.new(params[:usuario])
  		if @usuario.save
  			flash[:status] = TRUE
  			flash[:alert] = 'Usuario Registrado Exitosamente!!!'
  			else
  			flash[:status] = FALSE
  			flash[:alert] = @usuario.errors.full_messages
  			end
  		redirect_to :action => 'new', :format => 'html'
  end
end
