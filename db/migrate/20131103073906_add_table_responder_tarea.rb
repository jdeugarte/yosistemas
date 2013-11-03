class AddTableResponderTarea < ActiveRecord::Migration
  def change
    create_table :responder_tareas do |t|
      t.string :descripcion
      t.references :grupo, index: true
      t.references :usuario, index: true
      t.references :tarea, index: true
      t.timestamps
    end
end
end
