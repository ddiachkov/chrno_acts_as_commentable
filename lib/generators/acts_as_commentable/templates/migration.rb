# encoding: utf-8
class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      # DO NOT REMOVE
      t.integer :commentable_id,   null: false  # Комментируемый объект
      t.string  :commentable_type, null: false
      t.text    :body, null: false              # Текст комментария
      t.integer :author_id, null: false         # Автор комментария
      #####

      t.timestamps
    end

    add_index :comments, [ :commentable_id, :commentable_type ]
  end
end