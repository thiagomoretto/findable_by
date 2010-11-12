class BetweenFinder < Finder
  def build_condition(relation, attribute, value, params)
    relation.where([ "#{relation.table_name}.#{attribute} BETWEEN ? AND ?", value.first, value.last ])
  end
end