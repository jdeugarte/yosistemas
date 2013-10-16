class CreateNotificacions < ActiveRecord::Migration
  def change
    create_table :notificacions do |t|
      t.boolean :notificado

      t.timestamps
    end
  end
end
