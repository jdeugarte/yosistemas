class AddModerationToGrupos < ActiveRecord::Migration
  def change
  	add_column :grupos, :moderacion, :boolean
  end
end
