class CreateCuestionarios < ActiveRecord::Migration
  def change
    create_table :cuestionarios do |t|
      t.string :titulo
      t.text :descripcion
      t.date :fecha_limite
      t.time :hora_limite
      t.boolean :estado
      t.references :grupo, index: true
      t.references :usuario, index: true

      t.timestamps
    end
  end
end
