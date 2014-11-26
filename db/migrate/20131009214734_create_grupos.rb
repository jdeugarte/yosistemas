class CreateGrupos < ActiveRecord::Migration
  def change
    create_table :grupos do |t|
      t.string :nombre
      t.text :descripcion
      t.boolean :estado
      t.boolean :habilitado
      t.string :llave
      t.references :usuario, index: true

      t.timestamps
    end

    create_table :grupos_temas, id: false do |t|
      t.integer :grupo_id
      t.integer :tema_id
    end

    create_table :grupos_tareas, id: false do |t|
      t.integer :grupo_id
      t.integer :tarea_id
    end

    create_table :eventos_grupos, id: false do |t|
      t.integer :grupo_id
      t.integer :evento_id
    end

    
  end
end
