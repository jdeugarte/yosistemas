class CreateCommentTasks < ActiveRecord::Migration
  def change
    create_table :comment_tasks do |t|
      t.references :tarea, index: true
      t.references :usuario, index: true
      t.text :body

      t.timestamps
    end
  end
end
