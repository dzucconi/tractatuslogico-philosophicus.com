module Tractatus
  class Tree
    attr_reader :lines, :root

    def initialize(lines)
      @lines = lines
      @root = ::Tree::TreeNode.new("Tractatus Logico-Philosophicus")

      build!
    end

    def build!
      prev_depth = 0
      prev_node = root

      lines.each do |line|
        line = Line.new(line)

        # Traverse up to appropriate parent
        chain = (prev_depth - (line.depth - 1)).times.collect { "parent" }
        parent = chain.inject(prev_node, &:send)

        # If node is nil then we are grafting onto the root node
        (parent.nil? ? root : parent) << line.node

        # Setup for next loop
        prev_depth = line.depth
        prev_node = line.node
      end
    end
  end # Tree

  class Line
    attr_reader :line, :node

    def initialize(line)
      @line = line
      @node = ::Tree::TreeNode.new(name, statement)
    end

    def match;     @match     ||= /^\d.\d*/.match(line); end
    def name;      @name      ||= match.to_s; end
    def depth;     @depth     ||= match.to_s.split(".")[1].try(:size) || 0; end
    def statement; @statement ||= match.post_match.strip; end
  end # Line
end # Tractatus

class Application < Sinatra::Base
  use Rack::Static, urls: ["/stylesheets"], root: "public"

  get "/" do
    @lines = File.open("./resources/txt/tractatus.txt").read.split("\n")
    @tractatus = Tractatus::Tree.new(@lines)

    erb :index
  end
end # Application
