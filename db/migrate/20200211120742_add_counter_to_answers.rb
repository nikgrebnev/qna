class AddCounterToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :counter, :integer, null: false, default: 0
    add_index :answers, :counter
  end
end
