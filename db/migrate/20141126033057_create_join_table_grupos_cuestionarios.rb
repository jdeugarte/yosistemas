class CreateJoinTableGruposCuestionarios < ActiveRecord::Migration
   create_table :cuestionarios_grupos, id: false do |t|
      t.integer :cuestionario_id
      t.integer :grupo_id
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
