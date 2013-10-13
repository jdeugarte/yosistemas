class SuscripcionTema < ActiveRecord::Base
  belongs_to :temas
  belongs_to :usuarios
end
