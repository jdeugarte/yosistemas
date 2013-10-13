class UsuariosController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_log_in ,:only=>[:confirm,:new,:create,:forgot_password,:send_password_mail,:recover,:password_recovered]   
  
  def index
  end

  def show
    @usuario=Usuario.find(params[:id])
  end
  def password_recovered
    pass=params[:contrasenia_nueva].to_s
    newPass=params[:contrasenia_nueva2].to_s
    @usuario=Usuario.find(params[:id])
      if (pass==newPass)
        if(pass.length>5)
        @usuario.contrasenia=Digest::MD5.hexdigest(pass)
        @usuario.save
        redirect_to root_url
        else
          flash[:alert]= 'la longitud minima es 6'   
          redirect_to(:back)
        end 
      else
        flash[:alert]= 'Las contrasenias no coinciden'   
        redirect_to(:back)

      end
   end
  def edit
	 @usuario=current_user
  end
  def forgot_password
    if(current_user!=nil)
          redirect_to root_url
    end
  end
  def send_password_mail
    if(current_user==nil)
    mail=params[:mail]
    @usuario=Usuario.where(:correo=>mail,:activa=>true).first
    if(@usuario!=nil)
    if ( verify_recaptcha )
      p=Passwords_Request.new(:usuario_id=>@usuario.id)
      p.save
      @usuario.passwords_request_id=p.id
      @usuario.save
      SendMail.recover_password(@usuario,p.id).deliver
    else
        flash[:alert] = 'Ingrese las palabras correctamente'   
      redirect_to :action => 'forgot_password', :format => 'html'
    end
    else
      flash[:alert] = 'No existe ningun usuario con ese correo'   
      redirect_to :action => 'forgot_password', :format => 'html'
    end
  else
    redirect_to root_url
  end
  end


  def recover

  if(current_user!=nil)
     @errorMessagge="no puede recuperar su password si esta loggeado"
  else      
  begin
    password_request=Passwords_Request.find(params[:id])
    rescue ActiveRecord::RecordNotFound
  end
    if(password_request!=nil)
        if(password_request.usuario.passwords_request_id==password_request.id)
           @usuario=password_request.usuario
        else
          @errorMessagge="esta solicitud expiro, por favor solicite otra"
        end
    else
        @errorMessagge="no podemos procesar esta solicitud, por favor solicite otra"
    end
  end
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
    encriptado=Digest::MD5.hexdigest(uno)
    contrasenia=params[:contrasenia].to_s
    contrasenia=Digest::MD5.hexdigest(contrasenia)
    if current_user.contrasenia==contrasenia
      if uno==dos
        current_user.contrasenia=encriptado
        current_user.save
        flash[:alert] = 'Contraseña modificada'
        redirect_to root_url :notice => 'iguales'
      else
        flash[:alert] = 'Las contrasenias no coinciden'
        redirect_to root_url :notice => 'diferentes' 
      end
    else
      flash[:alert] = 'la contrasenia no es correcta'
      redirect_to root_url :notice => 'incorrecta'
    end
  end

  def new
  	@usuario = Usuario.new
  end

def confirm 
  if(current_user==nil)
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
else
  @messagge="No puede activar su cuenta si esta loggeado";
end
end

  def create
  	  params.permit!
  		@usuario = Usuario.new(params[:usuario])
      @usuario.rol=params[:rol]
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
