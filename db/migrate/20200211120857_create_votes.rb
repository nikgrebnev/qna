class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :value
      t.references :user, null: false, foreign_key: true
      t.references :votable, polymorphic: true, null: false

      t.timestamps
      t.index [ :user_id ,:votable_id, :votable_type ], unique: true

    end
  end
end
