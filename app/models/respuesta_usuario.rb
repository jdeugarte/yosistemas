class RespuestaUsuario < ActiveRecord::Base
  belongs_to :cuestionario
  belongs_to :usuario
  belongs_to :pregunta
end
