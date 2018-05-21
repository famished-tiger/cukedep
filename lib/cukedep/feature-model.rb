# File: feature-model.rb

require 'tsort'
require 'csv'
require 'erb'
require 'pathname'

module Cukedep # This module is used as a namespace
# The internal representation of a set of feature files.
# Dependencies: use topological sort
# TSort module http://ruby-doc.org/stdlib-1.9.3/libdoc/tsort/rdoc/TSort.html
# See also: Is this topological sort in Ruby flawed?
class FeatureModel
  FeatureDependencies = Struct.new(:dependee, :dependents)

  # Helper class used internally by FeatureModel class.
  # Purpose: to try to create a valid dependency graph and perform a
  # topological sort of the nodes.
  class DepGraph
    include TSort # Mix-in module for topological sorting

    attr_reader(:dependencies)

    # Inverse lookup: from the feature file => FeatureDependencies
    attr_reader(:lookup)

    def initialize(theDependencies)
      @dependencies = theDependencies
      @lookup = dependencies.each_with_object({}) do |f_deps, subresult|
        subresult[f_deps.dependee] = f_deps
      end
    end

    # Method required by TSort module.
    # It is used to iterate over all the nodes of the dependency graph
    def tsort_each_node(&aBlock)
      return dependencies.each(&aBlock)
    end

    # Method required by TSort module.
    # It is used to iterate over all the children nodes of the given node.
    def tsort_each_child(aDependency, &aBlock)
      dependents = aDependency.dependents
      children = dependents.map { |feature| lookup[feature] }
      children.each(&aBlock)
    end
  end # class


  attr_reader(:feature_files)

  # An Array of FeatureDependencies
  attr_reader(:dependencies)

  def initialize(theFeatureFiles)
    @feature_files = validated_model(theFeatureFiles)
  end

  # Retrieve the feature file matching the given feature identifiers
  # theIds one or more Strings, each being one feature identifier
  def select_by_ids(*theIds)
    features_by_ids = id2features
    selection = theIds.each_with_object([]) do |an_id, sub_result|
      found_feature = features_by_ids[an_id]
      if found_feature.nil?
        raise StandardError, "No feature file with identifier '#{an_id}'."
      end
      sub_result << found_feature
    end

    return selection
  end

  # The list of feature files without identifiers
  def anonymous_features
    feature_files.select { |ff| ff.feature.anonymous? }
  end

  # Build an array of FileDependencies objects.
  def dependency_links
    if @dependencies.nil?
      # Build the mapping: feature identifier => feature
      features_by_id = id2features

      # Resolve the dependency tags
      resolve_dependencies(features_by_id)
    end

    return @dependencies
  end

  # Sort the feature files by dependency order.
  def sort_features_by_dep
    dep_links = dependency_links
    graph = DepGraph.new(dep_links)
    sorted_deps = graph.tsort

    all_sorted = sorted_deps.map(&:dependee)
    @sorted_features = all_sorted.reject { |f| f.feature.anonymous? }
  end

  # Generate CSV files detailing the feature to identifier mapping
  # and vise versa
  def mapping_reports(fileFeature2id, fileId2Feature, isVerbose = false)
    puts "  #{fileFeature2id}" if isVerbose
    # Generate the feature file name => feature identifier report
    CSV.open(fileFeature2id, 'wb') do |f|
      f << ['Feature file', 'Identifier']
      feature_files.each do |ff|
        identifier = ff.feature.identifier
        filename = File.basename(ff.filepath)
        f << [filename, identifier.nil? ? 'nil' : identifier]
      end
    end

    # Generate the feature file name => feature identifier report
    puts "  #{fileId2Feature}" if isVerbose
    CSV.open(fileId2Feature, 'wb') do |f|
      f << ['identifier', 'feature file']
      feature_files.each do |ff|
        identifier = ff.feature.identifier
        filename = File.basename(ff.filepath)
        f << [identifier, filename] unless identifier.nil?
      end
    end
  end

  # Create a graphical representation of the dependencies.
  # The result is a DOT file that can be rendered via the DOT
  # application from the GraphViz distribution.
  def draw_dependency_graph(theDOTfile, isVerbose = false)
    puts "  #{theDOTfile}" if isVerbose
    dot_file = File.open(theDOTfile, 'w')
    emit_heading(dot_file)
    emit_body(dot_file)
    emit_trailing(dot_file)
  end

  def emit_heading(anIO)
    dir = File.dirname(File.absolute_path(feature_files[0].filepath))
    heading = <<-DOT
// Graph of dependencies of feature files in directory:
// '#{dir}'
// This file uses the DOT syntax, a free utility from the Graphviz toolset.
// Graphviz is available at: www.graphviz.org
// File generated on #{Time.now.asctime}.

digraph g {
  size = "7, 11"; // Dimensions in inches...
  center = true;
  rankdir = BT; // Draw from bottom to top
  label = "\\nDependency graph of '#{dir}'";

  // Nodes represent feature files
DOT
    anIO.write heading
  end

  # Output the nodes as graph vertices + their edges with parent node
  def emit_body(anIO)
    anIO.puts <<-DOT
  subgraph island {
    node [shape = box, style=filled, color=lightgray];
DOT
    feature_files.each_with_index do |ff, i|
      draw_node(anIO, ff, i) if ff.feature.anonymous?
    end

    anIO.puts <<-DOT
    label = "Isolated features";
    }

  subgraph dependencies {
    node [shape = box, fillcolor = none];
DOT
    feature_files.each_with_index do |ff, i|
      draw_node(anIO, ff, i) unless ff.feature.anonymous?
    end
    anIO.puts <<-DOT
    label = "Dependencies";
  }

  // The edges represent dependencies
DOT
    dependencies.each { |a_dep| draw_edge(anIO, a_dep) }
  end

  # Output the closing part of the graph drawing
  def emit_trailing(anIO)
    anIO.puts '} // End of graph'
  end

  # Draw a refinement node in DOT format
  def draw_node(anIO, aFeatureFile, anIndex)
    basename = File.basename(aFeatureFile.filepath, '.feature')
    its_feature = aFeatureFile.feature
    if its_feature.anonymous?
      id_suffix = ''
    else
      id_suffix = " -- #{its_feature.identifier}"
    end
    anIO.puts %Q(    node_#{anIndex} [label = "#{basename}#{id_suffix}"];)
  end

  # Draw an edge between feature files having dependencies.
  def draw_edge(anIO, aDependency)
    source_id = feature_files.find_index(aDependency.dependee)
    target_ids = aDependency.dependents.map do |a_target|
      feature_files.find_index(a_target)
    end

    target_ids.each do |t_id|
      anIO.puts "\tnode_#{source_id} -> node_#{t_id};"
    end
  end

  def generate_rake_tasks(rakefile, theProjDir)
    puts "  #{rakefile}"
    grandparent_path = Pathname.new(File.dirname(__FILE__)).parent.parent
    template_source = File.read(grandparent_path + './templates/rake.erb')

    # Create one template engine instance
    engine = ERB.new(template_source)

    source_dir = File.absolute_path(Dir.getwd)
    proj_dir = File.absolute_path(theProjDir)
    anonymous = anonymous_features.map(&:basename)
    feature_ids = feature_files.map { |ff| ff.feature.identifier }
    feature_ids.compact!
    deps = dependencies.reject { |dep| dep.dependee.feature.anonymous? }

    # Generate the text representation with given context
    file_source = engine.result(binding)
    File.open(rakefile, 'w') { |f| f.write(file_source) }
  end


  protected

  def validated_model(theFeatureFiles)
    return theFeatureFiles
  end

  # Build the mapping: feature identifier => feature
  def id2features
    mapping = feature_files.each_with_object({}) do |file, mp|
      feature_id = file.feature.identifier
      mp[feature_id] = file unless feature_id.nil?
    end

    return mapping
  end

  # Given a feature identifier => feature mapping,
  # resolve the dependency tags; that is,
  # Establish links between a feature file object and its
  # dependent feature file objects.
  def resolve_dependencies(aMapping)
    @dependencies = []

    feature_files.each do |feature_file|
      feature = feature_file.feature
      its_id = feature.identifier
      dep_tags = feature.dependency_tags
      # Complain when self dependency detected
      if dep_tags.include?(its_id)
        msg = "Feature with identifier #{its_id} depends on itself!"
        raise StandardError, msg
      end

      # Complain when dependency tag refers to an unknown feature
      dependents = dep_tags.map do |a_tag|
        unless aMapping.include?(a_tag)
          msg_p1 = "Feature with identifier '#{its_id}'"
          msg_p2 = " depends on unknown feature '#{a_tag}'"
          raise StandardError, msg_p1 + msg_p2
        end
        aMapping[a_tag]
      end

      @dependencies << FeatureDependencies.new(feature_file, dependents)
    end

    return @dependencies
  end
end # class
end # module

# end of file
