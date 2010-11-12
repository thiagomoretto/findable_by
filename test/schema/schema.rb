ActiveRecord::Schema.define do
  
  create_table :people, :force => true do |t|
    t.string     :first_name, :null => false
    t.string     :last_name
    t.references :primary_contact
    t.string     :gender, :limit => 1
    t.references :number1_fan
    t.integer    :lock_version, :null => false, :default => 0
  end  
  
end