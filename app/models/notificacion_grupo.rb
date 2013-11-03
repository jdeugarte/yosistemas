class NotificacionGrupo < ActiveRecord::Base
  belongs_to :subscription
  belongs_to :tarea
end
