class CreateUsuarios < ActiveRecord::Migration
  def change
    create_table :usuarios do |t|
      t.string :nombre
      t.string :apellido
      t.string :contrasenia
      t.string :contrasenia_de_confirmacion
      t.string :correo
      t.date :fecha_nacimiento
      t.text :acerca_de
      t.integer :telefono
      t.boolean :push, default: true
      t.boolean :mailer, default: true
      t.timestamps
    end
  end
end