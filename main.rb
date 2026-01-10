require_relative './lib/tree'

n = 2_000_000
data = Array.new(n) { rand(0..n * 10) }
start_time = Time.now
tree = Tree.new(data)
end_time = Time.now
p "Tree of #{n} values took #{(end_time - start_time).round(2)} seconds to build"
rand_num = data[rand(0...n)]
start_time = Time.now
tree.find(rand_num)
end_time = Time.now
p "Time to find #{rand_num} took #{(end_time - start_time).round(2)} seconds"
