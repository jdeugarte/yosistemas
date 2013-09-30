require 'aescrypt'
class SendMail < ActionMailer::Base
      default from: 'notifications@example.com'
    def activate_acount(user)
    @user = user
    @url  = 'http://localhost:3000/usuarios/confirm?pass='+AESCrypt.encrypt(@user.id.to_s,"Taller")
    #@url  = 'http://yositemas.herokuapp.com/usuarios/confirm?pass='+AESCrypt.encrypt(@user.id.to_s,"Taller")
    mail(to: @user.correo, subject: 'YoSistemas')
  end

end
