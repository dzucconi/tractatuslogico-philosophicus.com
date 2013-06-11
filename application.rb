class Application < Sinatra::Base
  use Rack::Static, urls: ["/stylesheets"], root: "public"

  helpers do
    def build_tree(lines)
      root = Tree::TreeNode.new("Tractatus Logico-Philosophicus")

      prev_depth = 0
      prev_node = root

      lines.each do |line|
        match = /^\d.\d*/.match(line)

        cur_depth = match.to_s.split(".")[1].try(:size) || 0
        cur_node = Tree::TreeNode.new(match.to_s, match.post_match.strip)

        # Determine number of parents to traverse
        chain = (prev_depth - (cur_depth - 1)).times.collect { "parent" }

        node = chain.inject(prev_node, &:send)

        # If node is nil then we are grafting onto the root node
        (node.nil? ? root : node) << cur_node

        # Setup for next loop
        prev_depth = cur_depth
        prev_node = cur_node
      end

      root
    end # build_tree
  end # helpers

  get "/" do
    @lines = File.open("./resources/txt/tractatus.txt").read.split("\n")
    @tree = build_tree(@lines)

    erb :index
  end
end # Application
