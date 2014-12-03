class AddGruposDirigidosToEventos < ActiveRecord::Migration
  def change
    add_column :eventos, :grupos_dirigidos, :string
  end
end
