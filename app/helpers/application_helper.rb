module ApplicationHelper	
  	def avatar_tam_url(user,tam)		
    	gravatar_id = Digest::MD5::hexdigest(user.correo).downcase
    	"http://gravatar.com/avatar/#{gravatar_id}.png?s=#{tam}&d=wavatar"
  	end
end
