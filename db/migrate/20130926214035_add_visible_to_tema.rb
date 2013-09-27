class AddVisibleToTema < ActiveRecord::Migration
  def change
    add_column :temas, :visible, :int
  end
end
