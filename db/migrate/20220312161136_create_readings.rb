class CreateReadings < ActiveRecord::Migration[5.2]
  def change
    create_table :readings do |t|
      t.integer  :reading
      t.datetime :date
      t.belongs_to :user, index: true
      t.timestamps
    end
    add_index(:readings, :date, name: :date_index)
  end
end
