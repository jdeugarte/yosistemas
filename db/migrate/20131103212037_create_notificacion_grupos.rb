class CreateNotificacionGrupos < ActiveRecord::Migration
  def change
    create_table :notificacion_grupos do |t|
      t.boolean :notificado
      t.references :subscription, index: true
      t.references :tarea, index: true

      t.timestamps
    end
  end
end
