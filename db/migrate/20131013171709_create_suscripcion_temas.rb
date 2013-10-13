class CreateSuscripcionTemas < ActiveRecord::Migration
  def change
    create_table :suscripcion_temas do |t|
      t.references :temas, index: true
      t.references :usuarios, index: true

      t.timestamps
    end
  end
end
