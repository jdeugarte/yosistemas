class CreateTemas < ActiveRecord::Migration
  def change
    create_table :temas do |t|
      t.string :titulo
      t.text :cuerpo
      t.text :grupos_pertenece, :default => [].to_yaml
      t.references :usuario, index: true
      t.timestamps
    end
  end
end