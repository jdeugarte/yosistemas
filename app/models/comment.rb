class Comment < ActiveRecord::Base
  belongs_to :tema
  belongs_to :usuario

  validates :body, :presence => true 
end
