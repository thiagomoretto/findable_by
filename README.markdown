findable_by
=

findable_by is a simple Rails 3 plugin to improve a way how you search for records. You can pass the search form parameters directly to the find_with method in your relation, by example. The plugin will take care to build a correct query in a safer way. This plugin doesn't modify the default behaviour of query engine of Rails3, but gives a new way to do your queries. You can use the both ways at same time without problems.

This plugin is designed to improve a way how to find records when you have a search forms, and in a standardized, cleaner and safer way to link the parameters from search form to model that declares how to search them.

See below how it's works.

Install:
-

In your Gemfile:

    gem "findable_by"

Usage
-

In your model you need to declare what the attributes you want to make "findable". For each, you can declare the way how it is "findable". You can declare more to one attribute in same line that use same way.

    class Person < ActiveRecord::Base
      scope :gender, proc { |value| where(:gender => value) }
      scope :by_department_name, proc { |value| joins(:department).where(:department => { :name => value }) }
  
      findable_by :first_name,          :using => :like
      findable_by :last_name,           :using => UpcaseFinder
      findable_by :primary_contact_id,  :using => :equals
      findable_by :number1_fan,         :using => proc { |attribute, value| where("1=1") }
      findable_by :gender,              :using => proc { |attribute, value| gender(value) }
      findable_by :age, :birth_date,    :using => :between, :with => [ :min, :max ]
      
      belongs_to :department
      
      # When department_name is setted "findable_by" will call :by_department_name named scope
      # passing the value by parameter.
      findable_by :department_name,     :through => :by_department_name
    end
    
And now you can search:

    relation = Person.scoped
    relation = relation.find_with(params[:search]) # :search => { :first_name => "Jose", :last_name => "Lito", 
                                                   #              :age => { :min => 25, :max => 45 } }

    relation.where(:gender => 'M').limit(1).all
    # Will generate... (sqlite3)
    # SELECT "people".* FROM "people" WHERE 
    #           (people.age BETWEEN 25 AND 45) 
    #       AND (UPPER(people.first_name) LIKE '%' ||    UPPER('Jose') || '%') 
    #       AND ("people"."last_name" = 'LITO') AND ("people"."gender" = 'M') LIMIT 1
  
You can create your own finders. Just create a class in your lib/ that extends Finder and respond_to "build_condition". Example, if you need to create a finder that upcase the value before creation the condition, you finder looks like this:

    class UpcaseFinder < Finder
      def build_condition(relation, attribute, value, params)
        relation.where(attribute => value.upcase!)
      end
    end

You can do much more! By example, create finders that sanitize or normalize inputs, scaling your productivity. In some cases too, you need to call a DB-specific function in where clause, you can write and Finder to do it and maintain your model more cleaner.

Help wanted for...
-

To make a better documentation and improve testing. Pull requests are welcome.

Bugs and Feedback
-

If you see any bugs or if you have a comment to do, please, write a issue here:

http://github.com/thiagomoretto/findable_by/issues

MIT License. Copyright 2010.