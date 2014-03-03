class AddBudgetToUsers < ActiveRecord::Migration
  def change
    add_column :users, :budget_id, :int
  end
end
