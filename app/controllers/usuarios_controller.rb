class UsuariosController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_log_in ,:only=>[:confirm,:new,:create]   
  
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
    if(current_user.save)
      flash[:alert] = 'Usuario Modificado'
    else
      flash[:alert] = current_user.errors.full_messages
      
    end
    redirect_to :action => 'edit', :format => 'html'
  end
  
  def update_password
    @usuario=current_user
  end
  
  def edit_password
    uno=params[:contrasenia_nueva].to_s
    dos=params[:contrasenia_nueva2].to_s
    contrasenia=params[:contrasenia].to_s
    if current_user.contrasenia==Digest::MD5.hexdigest(contrasenia)
      if uno==dos
          redirect_to root_url :notice => 'iguales'
      else
         redirect_to root_url :notice => 'diferentes' 
      end
    else
        redirect_to root_url :notice => 'no entra al if'
    end
    #redirect_to root_url :notice => params[:nueva_contrasenia].to_s
  end

  def new
  	@usuario = Usuario.new
  end

def confirm 
    @messagge="Error, datos invalidos"
  begin
    #usuario= Usuario.find(AESCrypt.decrypt(params[:pass].to_s,"Taller"))
    usuario= Usuario.find(params[:pass].to_s)
    rescue ActiveRecord::RecordNotFound
    rescue OpenSSL::Cipher::CipherError
 end
  if(usuario!=nil)
    if(!usuario.activa)
    usuario.activa=true
    usuario.save  
    @messagge="Su cuenta fue activada exitosamente! ya puede hacer uso de nuestro contenido";
    end
  end
end

  def create
  	  params.permit!
  		@usuario = Usuario.new(params[:usuario])
  		if @usuario.save
        SendMail.activate_acount(@usuario).deliver
  			flash[:status] = TRUE
  			flash[:alert] = 'Usuario Registrado Exitosamente!!! Revise su correo electronico para activar la cuenta'
  			else
  			flash[:status] = FALSE
  			flash[:alert] = @usuario.errors.full_messages
  			end
  		redirect_to :action => 'new', :format => 'html'  		 
  end
end
