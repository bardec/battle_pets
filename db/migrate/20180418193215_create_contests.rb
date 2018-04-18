class CreateContests < ActiveRecord::Migration[5.2]
  def change
    create_table :contests do |t|
      t.datetime :completed_at
      t.string :status
      t.string :winner
      t.string :contest_type
      t.string :first_competitor
      t.string :second_competitor

      t.timestamps
    end
  end
end
