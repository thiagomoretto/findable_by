class ScopeFinder < Finder
  attr_accessor :named_scope
  def initialize(options, named_scope)
    super(options)
    self.named_scope = named_scope
  end
  
  def build_condition(relation, attribute, value, params)
    relation.send(named_scope, value) if relation.respond_to?(named_scope)
  end
end