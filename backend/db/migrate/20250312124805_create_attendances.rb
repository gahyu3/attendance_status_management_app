class CreateAttendances < ActiveRecord::Migration[7.2]
  def change
    create_table :attendances do |t|
      t.date :date,                     null: false
      t.string :schedule,               :default => "出席予定"
      t.string :attendances_status,      :default => "出席中"
      t.string :remarks
      t.references :user,               null: false, foreign_key: true
      t.references :group,              null: false, foreign_key: true
      t.timestamps
    end
  end
end
