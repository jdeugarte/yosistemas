class CreateUsuarios < ActiveRecord::Migration
  def change
    create_table :usuarios do |t|
      t.string :nombre
      t.string :apellido
      t.string :contrasenia
      t.string :correo
      

      t.timestamps
    end
  end
end
