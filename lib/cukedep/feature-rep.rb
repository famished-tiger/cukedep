# File: feature-rep.rb

module Cukedep # This module is used as a namespace
# A FeatureRep is the internal representation of a Gherkin feature.
class FeatureRep
  # Constant that specifies how feature identifier tags should begin
  FeatureIdPrefix = /^feature:/
  
  # Constant that specifies how dependency tags should begin
  DependencyPrefix = /^depends_on:/
  
  # The sorted list of all tags of the feature.
  # The @ prefix is stripped from each tag text.
  attr_reader(:tags)
  
  # The identifier of the feature. 
  # It comes from a tag with the following syntax '@feature:' + identifier.
  # Note that the @feature: prefix is removed.
  attr_reader(:identifier)


  # theTags the tags objects from the Gherkin parser
  def initialize(theTags)
    # Strip first character of tag literal.
    @tags = theTags.map { |t| t[1..-1] }
    
    @identifier = tags.find { |tg| tg =~ FeatureIdPrefix }
    @identifier = @identifier.sub(FeatureIdPrefix, '') unless identifier.nil?
  end
  
  public

  # The list of all feature identifiers retrieved from the dependency tags
  def dependency_tags()
    dep_tags = tags.select { |t| t =~ DependencyPrefix }
    return dep_tags.map { |t| t.sub(DependencyPrefix, '') }
  end
  
  # Return true iff the identifier of the feature is nil.
  def anonymous?()
    return identifier.nil?
  end
end # class
end # module

# End of file
