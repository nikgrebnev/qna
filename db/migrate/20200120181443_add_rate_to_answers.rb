class AddRateToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :best, :boolean, default: false
    add_index :answers, [:question_id, :best], unique: true, where: "best = true"
  end
end
