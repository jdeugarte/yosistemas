class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.references :tema, index: true
      t.references :usuario, index: true
      t.references :notificacion, index: true
      t.timestamps
    end
  end
end
