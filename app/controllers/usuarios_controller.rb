class UsuariosController < ApplicationController
  
  skip_before_filter :require_log_in , :only=>[:new,:create, :edit] 
  
  def index
  end

  def show
  end
  
  def edit
	 @usuario=current_user
  end
  
  def update
    current_user.nombre=params[:usuario][:nombre]
    current_user.apellido=params[:usuario][:apellido]
    current_user.correo=params[:usuario][:correo]
    if(current_user.save)
      #flash[:status] = TRUE
      flash[:alert] = 'Usuario Modificado'
      redirect_to :action => 'show', :format => 'html'
    else
      flash[:alert] = current_user.errors.full_messages
      redirect_to :action => 'edit', :format => 'html'
    end
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
