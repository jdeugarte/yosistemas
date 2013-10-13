class AddColumnPasswordRequest < ActiveRecord::Migration
  def change
  	add_column :usuarios, :passwords_request_id, :integer
  end
end