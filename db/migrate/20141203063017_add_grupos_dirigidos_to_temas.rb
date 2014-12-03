class AddGruposDirigidosToTemas < ActiveRecord::Migration
  def change
    add_column :temas, :grupos_dirigidos, :text
  end
end
