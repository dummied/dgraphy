module Dgraphy
  class Node
    attr_reader :starter, :filter, :fields, :results

    def initialize(starter:, filter: nil, fields: [])
      @starter  = starter
      @filter   = filter
      @fields   = fields
    end

    def execute
      puts build_query
    end

    def build_query
      %Q(
        {
          dgraphy_query(func: #{starter})#{" @filter(#{filter})" if filter} {
            #{build_nodes}
          }
        }
      )
    end

    def build_nodes
      fields.map{ |field| build_node(field) }.join("\n\n")
    end

    def build_node(field)
      if field.is_a? String
        field
      elsif field.is_a? Dgraphy::Node
        %Q(
          #{field.starter}#{" @filter(#{field.filter})" if field.filter} {
            #{field.build_nodes}
          }
        )
      end
    end
  end
end
