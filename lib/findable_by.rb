module FindableBy
  module Relation
    def find_with(params)
      relation = self.dup
      params.each do |attribute, value|
        finder = self._finders[attribute]

        if not finder.blank?
          if not finder.options[:with].blank?
            # value is replaced in this case.
            value = _fb_override_value(attribute, finder.options[:with], params)
          end
          
          if _fb_is_value_ok(value) 
            relation = finder.send(:build_condition, relation, attribute, value, params) 
          end
        end
      end if not params.blank?
      
      relation
    end
  
  private
    def _fb_is_value_ok(value)
      not value.blank? or (value.is_a?(Hash) and value.all?)
    end
  
    def _fb_override_value(attribute, with_opts, params)
      case with_opts
      when Symbol
        raise NotImplementedError
      when Array
        value = with_opts.collect{ |wp| params[attribute][wp] }
      end
      value
    end
  end
  
  module ActsAsFindable
    extend ActiveSupport::Concern
    
    included do 
      class_attribute :_finders
      self._finders = HashWithIndifferentAccess.new{ |h,k| h[k] = [] }
    end
        
    private
      module ClassMethods
        def findable_by(*attr_names)
          options = attr_names.extract_options!
          options.merge!(:attributes => attr_names.flatten)
          options[:attributes].each do |attribute|
            using, through = options[:using], options[:through]
            if not using.blank? and not through.blank?
              raise ArgumentError, "You cannot use :using and :through at same time" 
            end
            
            options[:using] = :equals if through.blank? and using.blank?

            if not through.blank?
              self._finders[attribute] = ScopeFinder.new(options, through)
            else
              self._finders[attribute] =
              case using
              when Class
                using.send(:new, options)
              when Proc
                ProcFinder.new(options, using)
              when Symbol
                Kernel.const_get("#{options[:using]}_finder".classify).new(options)
              else
                raise ArgumentError, ":using must be: a Class, a Proc or a Symbol"
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
  attr_accessor :options
  def initialize(options)
    self.options = options
  end
  
  def build_condition(relation, attribute, value, params)
    raise NotImplementedError
  end
end

Dir[File.dirname(__FILE__) + "/findable_by/finders/*.rb"].sort.each do |path|
  filename = File.basename(path)
  require "findable_by/finders/#{filename}"
end

ActiveRecord::Base.send(:include, FindableBy::ActsAsFindable)
ActiveRecord::Relation.send(:include, FindableBy::Relation)