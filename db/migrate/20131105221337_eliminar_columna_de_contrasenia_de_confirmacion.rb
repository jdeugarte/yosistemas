class EliminarColumnaDeContraseniaDeConfirmacion < ActiveRecord::Migration
  
  def self.up
    remove_column :usuarios, :contrasenia_de_confirmacion
  end
  
  def self.down
    remove_column :usuarios, :contrasenia_de_confirmacion, :string
  end
 
end
