class AddMostrarCorreoToUsuarios < ActiveRecord::Migration
  def change
    add_column :usuarios, :mostrar_correo, :boolean
  end
end
