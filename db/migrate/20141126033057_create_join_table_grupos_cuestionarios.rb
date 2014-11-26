class CreateJoinTableGruposCuestionarios < ActiveRecord::Migration
   create_table :cuestionarios_grupos, id: false do |t|
      t.integer :cuestionario_id
      t.integer :grupo_id
    end
end
