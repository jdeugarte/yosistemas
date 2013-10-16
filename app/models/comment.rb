class Comment < ActiveRecord::Base
  belongs_to :tema
  belongs_to :usuario
  has_many :notificacions
  validates :body, :presence => true 
end
