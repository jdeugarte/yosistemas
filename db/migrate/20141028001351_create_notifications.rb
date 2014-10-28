class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :title
      t.string :description
      t.date :reference_date
      t.integer :tipo
      t.boolean :seen
      t.integer :de_usuario_id
      t.integer :para_usuario_id
      t.integer :id_item
      t.timestamps
    end
  end
end
