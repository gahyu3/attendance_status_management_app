class CreateAttendances < ActiveRecord::Migration[7.2]
  def change
    create_table :attendances do |t|
      t.date :date,                     null: false
      t.string :schedule
      t.string :attendances_status
      t.string :remarks
      t.references :user,               null: false, foreign_key: true
      t.references :group,              null: false, foreign_key: true
      t.timestamps
    end
  end
end
