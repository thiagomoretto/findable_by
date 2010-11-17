class UpcaseFinder < Finder
  def build_condition(relation, attribute, value, params)
    relation.where(attribute => value.upcase!)
  end
end

class Person < ActiveRecord::Base
  scope :gender, proc { |value| where(:gender => 'F') }
  scope :by_department_name, proc { |value| joins(:department).where(:department => { :name => value }) }
  
  findable_by :first_name,          :using => :like
  findable_by :last_name,           :using => UpcaseFinder
  findable_by :primary_contact_id,  :using => :equals
  findable_by :number1_fan,         :using => proc { |attribute, value| where("1=1") }
  findable_by :gender,              :through => :gender
  findable_by :age,                 :using => :between, :with => [ :min, :max ]
  findable_by :birth_date,          :using => :between, :with => [ :min, :max ]
  
  belongs_to :department
  
  findable_by :department_name,     :through => :by_department_name
end

class Department < ActiveRecord::Base; end 