class AddGruposPertenecenToCuestionarios < ActiveRecord::Migration
  def change
  	add_column :cuestionarios, :grupos_pertenecen, :text
  end
end
