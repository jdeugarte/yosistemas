require 'aescrypt'
class SendMail < ActionMailer::Base
      default from: 'notifications@example.com'
    def activate_acount(user)
    @user = user
    @url  = 'http://localhost:3000/usuarios/confirm/'+AESCrypt.encrypt(@user.id.to_s,"ah2Srnbs7E4gRt0")
    mail(to: @user.correo, subject: 'YoSistemas')
  end

end
