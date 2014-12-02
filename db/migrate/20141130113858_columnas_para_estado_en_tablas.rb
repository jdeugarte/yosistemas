class ColumnasParaEstadoEnTablas < ActiveRecord::Migration
  def change
  	add_column :temas, :admitido, :boolean,:default => false
  	add_column :tareas, :admitido, :boolean,:default => false
  	add_column :eventos, :admitido, :boolean,:default => false
  end
end
