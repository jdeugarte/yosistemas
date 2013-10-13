class CreatePasswordsRequest < ActiveRecord::Migration
     def change
  	  create_table :passwords_requests do |t|
   	  t.references :usuario, index: true
      t.timestamps
    end
  end
end
