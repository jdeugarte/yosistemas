class AddPushQuestToUsuarios < ActiveRecord::Migration
  def change
  	add_column :usuarios, :push_quest, :boolean, :default=>true
	add_column :usuarios, :mailer_quest, :boolean, :default=>true
	add_column :cuestionarios, :admitido, :boolean,:default => false  	 
  end
end
