class UsuariosController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_log_in ,:only=>[:confirm,:new,:create,:forgot_password,:send_password_mail,:recover]   
  
  def index
  end

  def show
    @usuario=Usuario.find(params[:id])
  end
  
  def edit
	 @usuario=current_user
  end
  def forgot_password
  end
  def send_password_mail
    mail=params[:mail]
    @usuario=Usuario.where(:correo=>mail,:activa=>true).first
    if(@usuario!=nil)
      p=Passwords_Request.new(:usuario_id=>@usuario.id)
      p.save
      @usuario.passwords_request_id=p.id
      @usuario.save
      SendMail.recover_password(@usuario,p.id).deliver
     
    else
      flash.now[:notice] = "no existe ningun usuario con ese correo"
      #render 'send_password_mail'
    end
  end
  def recover
  if(current_user!=nil)
      #no puede recuperar loggeado
  else      
    password_request=Passwords_Request.find(params[:id])
    if(password_request!=nil)
        if(password_request.usuario.passwords_request_id==password_request.id)
            @usuario=password_request.usuario
        else
          #expiro
        end
    else
    end
  end
  #  redirect_to :action => 'new', :format => 'html'
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
    contrasenia=Digest::MD5.hexdigest(contrasenia)
    if current_user.contrasenia==contrasenia
      if uno==dos
        current_user.contrasenia=contrasenia
        current_user.save
        redirect_to root_url :notice => 'iguales'
      else
        flash[:alert] = 'Las contrasenias no coinciden'
        redirect_to root_url :notice => 'diferentes' 
      end
    else
      flash[:alert] = 'la contrasenia no es correcta'
      redirect_to root_url :notice => 'no entra al if'
    end
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
