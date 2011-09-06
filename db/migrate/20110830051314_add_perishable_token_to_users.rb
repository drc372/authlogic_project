class AddPerishableTokenToUsers < ActiveRecord::Migration
  def self.up
    # Add the perishable token for one-time email password reset use
    change_table :users do |t|
      t.string    :perishable_token
    end

    User.reset_column_information

    # Go through and give any users in the database the non-null token
    User.find_each do |user|
      user.perishable_token = Authlogic::Random.friendly_token
      user.save!
    end

    # Force the token column to be non-null
    change_column :users, :perishable_token, :string, :null => false
    
    # Make the token an index for fast lookup in the database
    add_index :users, ["perishable_token"], :name => "index_users_on_perishable_token", :unique => true

  end

  def self.down
    remove_column :users, :perishable_token  
  end
end
