class CreateCheckpoints < ActiveRecord::Migration[5.1]
  def change
    create_table :checkpoints do |t|
      t.belongs_to :race_result, foreign_key: true
      t.integer :reader_id
      t.integer :stage_id
      t.datetime :time

      t.timestamps
    end
  end
end
