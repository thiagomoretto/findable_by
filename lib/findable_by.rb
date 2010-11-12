module FindableBy
  module Relation
    def find_with(params)
      relation = self.dup
      params.each do |attribute, value|
        finder = self._finders[attribute]
        if not value.blank? and not finder.blank?
          relation = finder.send(:build_condition, relation, attribute, value, params) 
        end
      end if not params.blank?
      
      relation
    end
  end
  
  module ActsAsFindable
    extend ActiveSupport::Concern
    
    included do 
      class_attribute :_finders
      self._finders = Hash.new{ |h,k| h[k] = [] }
    end
        
    private
      module ClassMethods
        def findable_by(*attr_names)
          options = attr_names.extract_options!
          options.merge!(:attributes => attr_names.flatten)
          if options.key?(:using)
            options[:attributes].each do |attribute|
              # attribute = options[:as] if options.key?(:as)
              using_what = options[:using]
              if using_what.is_a?(Class)
                self._finders[attribute] = using_what
              elsif using_what.is_a?(Proc)
                self._finders[attribute] = ProcFinder.new(using_what)
              else
                self._finders[attribute] = Kernel.const_get("#{options[:using]}_finder".classify)
              end
            end
          end
        end
        
        def inherited(base)
          dup = _finders.dup
          base._finders = dup.each{ |k,v| dup[k] = v.dup }
          super
        end
      end
  end
end

class Finder
  def build_condition(relation, attribute, value)
    raise NotImplementedError
  end
end

Dir[File.dirname(__FILE__) + "/findable_by/finders/*.rb"].sort.each do |path|
  filename = File.basename(path)
  require "findable_by/finders/#{filename}"
end

ActiveRecord::Base.send(:include, FindableBy::ActsAsFindable)
ActiveRecord::Relation.send(:include, FindableBy::Relation)