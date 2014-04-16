class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|

    	t.string :email_address
    	t.string :contact_name
    	t.text :message

      t.timestamps
    end
  end
end
