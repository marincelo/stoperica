class CreateAdvertables < ActiveRecord::Migration[5.1]
  def change
    create_table :advertables do |t|
    	t.references :race, null: false, foreign_key: true
    	t.references :advertisement, null: false, foreign_key: true
       t.timestamps
    end
  end
end
