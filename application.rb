module Tractatus
  class Tree
    attr_reader :lines, :root

    def initialize(lines)
      @lines = lines
      @root = ::Tree::TreeNode.new("Tractatus Logico-Philosophicus")

      build!
    end

    def build!
      [0, root].tap do |prev_depth, prev_node|
        lines.each do |line|
          line = Line.new(line)

          # Traverse up to appropriate parent
          parent = (prev_depth - (line.depth - 1)).times.collect do
            :parent
          end.inject(prev_node, &:send)

          # If node is nil then we are grafting onto the root node
          (parent.nil? ? root : parent) << line.node

          # Setup for next loop
          prev_depth, prev_node = line.depth, line.node
        end
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

  class Translations
    PATH = "./resources/txt"

    VERSIONS = {
        ogden: "#{PATH}/ogden.txt"
      }
  end # Translations
end # Tractatus

class Application < Sinatra::Base
  use Rack::Static, urls: ["/stylesheets", "/javascripts"], root: "public"

  get "/" do
    @lines = File.open(Tractatus::Translations::VERSIONS[:ogden]).read.split("\n")
    @tractatus = Tractatus::Tree.new(@lines)

    erb :index
  end
end # Application
