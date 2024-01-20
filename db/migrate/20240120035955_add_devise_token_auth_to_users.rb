class AddDeviseTokenAuthToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :provider, :string, null: false, default: "email"
    add_column :users, :uid, :string, null: false, default: ""
    add_column :users, :tokens, :text

    ## Recoverable
    add_column :users, :allow_password_change, :boolean, :default => false
  end
end
