ActiveRecord::Schema.define do
  
  create_table :people, :force => true do |t|
    t.string     :first_name, :null => false
    t.string     :last_name
    t.references :primary_contact
    t.string     :gender, :limit => 1
    t.integer    :number1_fan
    t.references :department
    t.integer    :age, :limit => 3
    t.integer    :lock_version, :null => false, :default => 0
  end  
  
  create_table :departments, :force => true do |t|
    t.string    :name, :null => false
  end
  
end