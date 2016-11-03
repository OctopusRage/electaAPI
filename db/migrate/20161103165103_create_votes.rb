class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.string :title
      t.string :description
      t.references :category, index: true, foreign_key: true
      t.date :started_at
      t.date :ended_at
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
