require_relative './lib/tree'

data = Array.new(15) { rand(1..100) }
tree = Tree.new(data)
10.times { tree.insert(rand(100..200)) }
tree.pretty_print
tree.rebalance
tree.pretty_print
