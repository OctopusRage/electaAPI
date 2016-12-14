class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :subject
      t.integer :from
      t.integer :to
      t.text :message

      t.timestamps null: false
    end
  end
end
