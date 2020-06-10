class AddSubscriptionIndex < ActiveRecord::Migration[6.0]
  def change
    add_index :subscription_idx, %i[user_id question_id], unique: true
  end
end
