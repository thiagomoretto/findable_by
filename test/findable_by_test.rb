require 'test_helper'

require 'support/models'

class FindableByTest < ActiveRecord::TestCase

  test "should generate a SQL to find a person by first name using like" do
    with_scoped(Person) do |person|
      assert_not_nil person.find_with(:first_name => "OMG!").to_sql =~ /LIKE/
    end
  end
  
  test "should generate a SQL to find a person using a proc" do
    with_scoped(Person) do |person|
      assert_not_nil person.find_with(:number1_fan => "Don't care").to_sql =~ /1=1/
    end
  end

  test "should generate a SQL to find a person using a proc calling a scope" do
    with_scoped(Person) do |person|
      sql = person.find_with("first_name" => "OMG!", :gender => 'M').to_sql
      assert_not_nil sql =~ /first_name/ and sql =~ /gender/
    end
  end
  
  test "should generate a SQL to find a person calling 'find_with' chained" do
    with_scoped(Person) do |person|
      assert_not_nil person.find_with(:first_name => "OMG!").find_with(:gender => 'F').to_sql =~ /first_name/
    end
  end
  
  test "should generate a SQL to find a person by primary_contact_id using equals" do
    with_scoped(Person) do |person|
      assert_not_nil person.find_with(:primary_contact_id => 1).to_sql =~ /primary_contact_id/
    end
  end
  
  test "should generate a SQL to find a person using a custom finder" do
    with_scoped(Person) do |person|
      assert person.find_with(:last_name => "omg").to_sql =~ /OMG/
    end
  end
  
  test "should generate a SQL to find people by age range" do
    with_scoped(Person) do |person|
      assert person.find_with(:age => { :min => 20, :max => 45 }).to_sql =~ /BETWEEN 20 AND 45/
    end
  end

  test "should generate a SQL to find people by birth date range" do
    with_scoped(Person) do |person|
      params, params[:birth_date] = {}, {}
      params[:birth_date][:min], params[:birth_date][:max] = Time.now - 1.day, Time.now + 1.day
      assert person.find_with(params).to_sql =~ /BETWEEN/
    end
  end
  
  test "should generate a SQL to find people by department name using like" do
    with_scoped(Person) do |person|
      assert_not_nil person.find_with(:department_name => "hr").to_sql =~ /"department"."name" = 'hr'/
    end
  end
  
private
  def with_scoped(model, &block)
    block.call(model.send(:scoped))
  end
end