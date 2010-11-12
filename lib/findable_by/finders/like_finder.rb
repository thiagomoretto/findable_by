class LikeFinder < Finder
  def build_condition(relation, attribute, value, params)
    relation.where([ "UPPER(#{relation.table_name}.#{attribute}) LIKE '%' || UPPER(?) || '%'", value ])
  end
end