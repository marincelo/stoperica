class CreateLeaguesClubsJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :leagues, :clubs do |t|
      t.index :league_id
      t.index :club_id
    end
  end
end
