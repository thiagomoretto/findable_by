class EqualsFinder < Finder
  def self.build_condition(relation, attribute, value, params)
    relation.where(attribute => value)
  end
end