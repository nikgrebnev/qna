class AddCounterToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :counter, :integer, null: false, default: 0
    add_index :questions, :counter
  end
end
