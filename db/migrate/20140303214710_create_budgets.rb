class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.string :name
      t.string :description
      t.decimal :allowance
      t.decimal :target
      t.date :start_date

      t.timestamps
    end
  end
end
