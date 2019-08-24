class AddCountAndLockToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :login_count, :integer
    add_column :users, :locked, :boolean
  end
end
