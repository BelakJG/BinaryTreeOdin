require_relative './lib/tree'

data = Array.new(15) { rand(1..100) }
tree = Tree.new(data)
p tree.balanced? ? 'The tree is balanced' : 'The tree is not balanced'
p tree.level_order
p tree.preorder
p tree.inorder
p tree.postorder
10.times { tree.insert(rand(100..200)) }
p tree.balanced? ? 'The tree is balanced' : 'The tree is not balanced'
puts 'rebalancing tree'
tree.rebalance
p tree.balanced? ? 'The tree is balanced' : 'The tree is not balanced'
p tree.level_order
p tree.preorder
p tree.inorder
p tree.postorder
tree.pretty_print
