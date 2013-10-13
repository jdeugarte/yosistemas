class Tarea < ActiveRecord::Base
  belongs_to :usuario
  belongs_to :grupo
end
