class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :llave
      t.references :usuario, index: true
      t.references :grupo, index: true

      t.timestamps
    end
  end
end
