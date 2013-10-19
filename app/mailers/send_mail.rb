require 'aescrypt'
class SendMail < ActionMailer::Base
	attr_accessor :url
      default from: 'YoSistemas@gmail.com'
    def activate_acount(user)
    @user = user
    #@url  = 'http://localhost:3000/usuarios/confirm?pass='+AESCrypt.encrypt(@user.id.to_s,"Taller")
    @url  = 'http://yosistemas.herokuapp.com/usuarios/confirm/'+@user.id.to_s #AESCrypt.encrypt(@user.id.to_s,"Taller")
    mail(to: @user.correo, subject: 'YoSistemas')
  end
  def recover_password(user,id)
    @user=user
    @url  = 'http://yosistemas.herokuapp.com/usuarios/recover/'+id.to_s
    #@url  = 'http://yosistemas.herokuapp.com/usuarios/confirm?pass='+@user.id.to_s #AESCrypt.encrypt(@user.id.to_s,"Taller")
    mail(to: @user.correo, subject: 'Password YoSistemas')
  end
  def notify_users_tema(user, tema)
    @user = user
    @tema=tema
    @url  = 'http://yosistemas.herokuapp.com/temas/'+tema.id.to_s
    mail(to: @user.correo,subject: 'YoSistemas comentario tema')
  end
  def notify_users_grupo(user,grupo_nombre)
    @user = user
    mail(to: @user.correo,subject: 'Te suscribiste a el grupo: '+grupo_nombre.to_s)
  end
end
