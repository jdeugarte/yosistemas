class Comment < ActiveRecord::Base
  belongs_to :tema
  belongs_to :usuario
  belongs_to :notificacion
  validates :body, :presence => true 
end
