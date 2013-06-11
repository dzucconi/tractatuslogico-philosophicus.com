class Application < Sinatra::Base
  helpers do
    def build_tree(lines)
      tree = Tree::TreeNode.new("Tractatus")

      prev_depth, cur_depth = 0, 0
      prev_node = tree

      lines.each_with_index do |line, i|
        match = /^\d.\d*/.match(line)
        node  = match.to_s

        parent    = node.split(".")[0]
        cur_depth = node.split(".")[1].try(:size) || 0
        statement = match.post_match.strip

        cur_node = Tree::TreeNode.new(node, statement)

        # If the current depth is the same as the previous depth than
        # the current line is a sibling of the previous line
        if cur_depth == 0
          puts "root"
          tree << cur_node
        elsif cur_depth == prev_depth
          puts "equal: #{cur_depth} #{prev_depth}"
          prev_node.parent << cur_node

        # If the current depth is greater than the previous depth than
        # the current line is a child of the previous line
        elsif cur_depth > prev_depth
          puts "greater: #{cur_depth} #{prev_depth}"
          prev_node << cur_node

        # If the current depth is lower than the previous depth than
        # the current line is a child of the parent of the previous line
        elsif cur_depth < prev_depth
          puts "lower: #{cur_depth} #{prev_depth}"

          chain = (prev_depth - (cur_depth - 1)).times.collect { "parent" }.join(".")

          n = eval "prev_node.#{chain}"
          n << cur_node
        end

        prev_depth = cur_depth
        prev_node  = cur_node
      end

      tree
    end # build_tree
  end # helpers

  get "/" do
    @lines = File.open("./tractatus.txt").read.split("\n")
    @tree = build_tree(@lines)

    erb :index
  end
end # Application
