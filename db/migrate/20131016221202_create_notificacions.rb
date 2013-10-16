class CreateNotificacions < ActiveRecord::Migration
  def change
    create_table :notificacions do |t|
      t.boolean :notificado
      t.references :suscripcion_temas, index: true
      t.references :comments, index: true
      t.timestamps
    end
  end
end
