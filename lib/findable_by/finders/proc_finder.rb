class ProcFinder < Finder
  attr_accessor :proc
  def initialize(options, proc)
    super(options)
    self.proc = proc
  end
  
  def build_condition(relation, attribute, value, params)
    relation & proc.call(attribute, value)
  end
end