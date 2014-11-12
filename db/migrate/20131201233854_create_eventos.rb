class CreateEventos < ActiveRecord::Migration
  def change
    create_table :eventos do |t|
      t.string :nombre
      t.string :detalle
      t.string :lugar
      t.date :fecha
      t.boolean :estado
      t.text :grupos_pertenece, :default => [].to_yaml
      t.references :grupo, index: true
      t.references :usuario, index: true

      t.timestamps
    end
  end
end
