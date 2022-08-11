class CreateAnnouncements < ActiveRecord::Migration[6.0]
  def change
    create_table :announcements do |t|
      t.string :kind
      t.string :title
      t.datetime :published_at

      t.timestamps
    end
  end
end
