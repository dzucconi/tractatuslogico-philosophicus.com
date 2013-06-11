class Application < Sinatra::Base
  use Rack::Static, urls: ["/stylesheets"], root: "public"

  helpers do
    def build_tree(lines)
      tree = Tree::TreeNode.new("Tractatus Logico-Philosophicus")

      prev_depth, cur_depth = 0, 0
      prev_node = tree

      lines.each_with_index do |line, i|
        match = /^\d.\d*/.match(line)
        node = match.to_s

        cur_depth = node.split(".")[1].try(:size) || 0
        cur_node = Tree::TreeNode.new(node, match.post_match.strip)

        # Determine number of parents to traverse
        chain = (prev_depth - (cur_depth - 1)).times.collect { "parent" }

        node = chain.inject(prev_node, &:send)

        # If node is nil then we are creating a root node
        (node.nil? ? tree : node) << cur_node

        # Setup for next loop
        prev_depth = cur_depth
        prev_node = cur_node
      end

      tree
    end # build_tree
  end # helpers

  get "/" do
    @lines = File.open("./resources/txt/tractatus.txt").read.split("\n")
    @tree  = build_tree(@lines)

    erb :index
  end
end # Application
