class UpcaseFinder < Finder
  def self.build_condition(relation, attribute, value, params)
    relation.where(attribute => value.upcase!)
  end
end

class Person < ActiveRecord::Base
  scope :gender, proc { |value| where(:gender => 'F') }
  
  findable_by :first_name,          :using => :like
  findable_by :last_name,           :using => UpcaseFinder
  findable_by :primary_contact_id,  :using => :equals
  findable_by :number1_fan,         :using => proc { |attribute, value| where("1=1") }
  findable_by :gender,              :using => proc { |attribute, value| gender(value) }
end