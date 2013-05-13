class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content
      t.datetime :send_at
      t.datetime :created_at
    end

    add_index :messages, [:content, :send_at], unique: true
  end
end
