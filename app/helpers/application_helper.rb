module ApplicationHelper
	def avatar_url(user)		
    	gravatar_id = Digest::MD5::hexdigest(user.correo).downcase
    	"http://gravatar.com/avatar/#{gravatar_id}.png?s=80&d=wavatar"
  	end

  	def avatar_perfil_url(user)		
    	gravatar_id = Digest::MD5::hexdigest(user.correo).downcase
    	"http://gravatar.com/avatar/#{gravatar_id}.png?s=140&d=wavatar"
  	end
end
