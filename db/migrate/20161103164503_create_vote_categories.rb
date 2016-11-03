class CreateVoteCategories < ActiveRecord::Migration
  def change
    create_table :vote_categories do |t|
      t.string :category
      t.string :description

      t.timestamps null: false
    end
  end
end
