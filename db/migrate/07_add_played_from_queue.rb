class AddPlayedFromQueue < ActiveRecord::Migration
  def self.up
    add_column :songs, :played_from_queue, :boolean
  end
  def self.down
    remove_column :songs, :played_from_queue
  end
end
