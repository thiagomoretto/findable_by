class EqualsFinder < Finder
  def build_condition(relation, attribute, value, params)
    relation.where(attribute => value)
  end
end