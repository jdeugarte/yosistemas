class EliminarColumnaDeContraseniaDeConfirmacion < ActiveRecord::Migration
  def change
  	remove_column :usuarios, :contrasenia_de_confirmacion, :string
  end
end
