require 'test_helper'

require 'support/models'

class FindableByTest < ActiveRecord::TestCase

  test "should generate a SQL to find a person by first name using like" do
    with_scoped(Person) do |person|
      assert_not_nil person.find_with(:first_name => "OMG!").to_sql
    end
  end
  
  test "should generate a SQL to find a person using a proc" do
    with_scoped(Person) do |person|
      assert_not_nil person.find_with(:number1_fan => "Don't care").to_sql
    end
  end

  test "should generate a SQL to find a person using a proc calling a scope" do
    with_scoped(Person) do |person|
      assert_not_nil person.find_with(:first_name => "OMG!", :gender => 'M').to_sql
    end
  end
  
  test "should generate a SQL to find a person calling 'find_with' chained" do
    with_scoped(Person) do |person|
      assert_not_nil person.find_with(:first_name => "OMG!").find_with(:gender => 'F').to_sql
    end
  end
  
  test "should generate a SQL to find a person by primary_contact_id using equals" do
    with_scoped(Person) do |person|
      assert_not_nil person.find_with(:primary_contact_id => 1).to_sql
    end
  end
  
  test "should generate a SQL to find a person using a custom finder" do
    with_scoped(Person) do |person|
      assert person.find_with(:last_name => "omg").to_sql =~ /OMG/
    end
  end

private
  def with_scoped(model, &block)
    block.call(model.send(:scoped))
  end
  
end