class AddColumnActivaToUsuario < ActiveRecord::Migration
  def change
  	add_column :usuarios, :activa, :boolean, :default=>true
  end
end
