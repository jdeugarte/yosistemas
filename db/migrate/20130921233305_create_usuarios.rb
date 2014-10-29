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
      t.boolean :push_task, default: true
      t.boolean :mailer_task, default: true
      t.boolean :push_theme, default: true
      t.boolean :mailer_theme, default: true
      t.boolean :push_event, default: true
      t.boolean :mailer_event, default: true
      t.timestamps
    end
  end
end