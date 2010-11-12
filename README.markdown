findable_by
=

findable_by is a simple Rails 3 plugin to improve a way how you search for records. You can pass the search form parameters directly to the find_with method in your relation, and the plugin will take care to build a correct query in a safer way.

See below how it's works.

Install:
-

In your Gemfile:

    gem "findable_by"

Usage
-

    class Person < ActiveRecord::Base
      scope :gender, proc { |value| where(:gender => value) }
  
      findable_by :first_name,          :using => :like
      findable_by :last_name,           :using => UpcaseFinder
      findable_by :primary_contact_id,  :using => :equals
      findable_by :number1_fan,         :using => proc { |attribute, value| where("1=1") }
      findable_by :gender,              :using => proc { |attribute, value| gender(value) }
    end
    
And now you can search:

    relation = Person.scoped
    relation = relation.find_with(params[:search])
    relation.all
  
TODO
-

README and some documentation.

Bugs and Feedback
-

http://github.com/thiagomoretto/findable_by/issues

MIT License. Copyright 2010.