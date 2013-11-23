class EliminarColumnaDeContraseniaDeConfirmacion < ActiveRecord::Migration
  def down
  	remove_column :usuarios, :contrasenia_de_confirmacion, :string
  end
end
