require_relative 'node'

class Tree
  attr_accessor :root

  def initialize(array = [])
    @root = build_tree(array.uniq.sort)
  end

  def build_tree(array)
    return nil if array.empty?

    mid_index = array.length / 2
    root_node = Node.new(array[mid_index])
    root_node.left_child = build_tree(array[0...mid_index])
    root_node.right_child = build_tree(array[mid_index + 1..])
    root_node
  end

  def insert(value, node = root)
    return Node.new(value) if node.nil?
    return node if node.value == value

    node.left_child = insert(value, node.left_child) if value < node.value
    node.right_child = insert(value, node.right_child) if value > node.value
    rebalance(node) if (find_height(node.left_child) - find_height(node.right_child)).abs > 3
    node
  end

  def delete(value, node = root)
    return node if node.nil?

    if value < node.value
      node.left_child = delete(value, node.left_child)
    elsif value > node.value
      node.right_child = delete(value, node.right_child)
    else
      return node.right_child if node.left_child.nil?
      return node.left_child if node.right_child.nil?

      closest_node = closest_succ(node.right_child)
      node.value = closest_node.value
      node.right_child = delete(closest_node.value, node.right_child)
    end
    node
  end

  def closest_succ(node)
    temp_node = node
    temp_node = temp_node.left_child until temp_node.left_child.nil?
    temp_node
  end

  def find(value, node = root)
    return nil if node.nil?
    return node if node.value == value

    left = find(value, node.left_child)
    right = find(value, node.right_child)
    left.nil? ? right : left
  end

  def level_order
    return [] if root.nil?

    queue = [root]
    unless block_given?
      values = []
      until queue.empty?
        queue.push(queue[0].left_child) unless queue[0].left_child.nil?
        queue.push(queue[0].right_child) unless queue[0].right_child.nil?
        values.push(queue.shift.value)
      end
      return values
    end

    until queue.empty?
      queue.push(queue[0].left_child) unless queue[0].left_child.nil?
      queue.push(queue[0].right_child) unless queue[0].right_child.nil?
      yield (queue.shift)
    end
  end

  def inorder(node = root, &block)
    return [] if node.nil?

    unless block_given?
      values = []
      values.concat(inorder(node.left_child)) unless node.left_child.nil?
      values << node.value
      values.concat(inorder(node.right_child)) unless node.right_child.nil?
      return values
    end

    inorder(node.left_child, &block) unless node.left_child.nil?
    block.call node
    inorder(node.right_child, &block) unless node.right_child.nil?
  end

  def preorder(node = root, &block)
    return [] if node.nil?

    unless block_given?
      values = []
      values << node.value
      values.concat(preorder(node.left_child)) unless node.left_child.nil?
      values.concat(preorder(node.right_child)) unless node.right_child.nil?
      return values
    end

    block.call node
    preorder(node.left_child, &block) unless node.left_child.nil?
    preorder(node.right_child, &block) unless node.right_child.nil?
  end

  def postorder(node = root, &block)
    return [] if node.nil?

    unless block_given?
      values = []
      values.concat(postorder(node.left_child)) unless node.left_child.nil?
      values.concat(postorder(node.right_child)) unless node.right_child.nil?
      values << node.value
      return values
    end

    postorder(node.left_child, &block) unless node.left_child.nil?
    postorder(node.right_child, &block) unless node.right_child.nil?
    block.call node
  end

  def height(value)
    node = find(value)
    return nil if node.nil?
    return 0 if node.leaf?

    find_height(node)
  end

  def find_height(node)
    return -1 if node.nil?

    left = find_height(node.left_child)
    right = find_height(node.right_child)
    1 + (left > right ? left : right)
  end

  def depth(value)
    return nil if root.nil?
    return 0 if root.value == value

    node = root
    depth = 0
    until node.value == value
      node = (value < node.value ? node.left_child : node.right_child)
      depth += 1
    end
    depth
  end

  def balanced?(node = root)
    return true if node.nil? || node.leaf?

    left_bal = balanced?(node.left_child)
    right_bal = balanced?(node.right_child)
    left_height = find_height(node.left_child)
    right_height = find_height(node.right_child)
    height_diff = (left_height - right_height).abs

    (height_diff <= 1) && left_bal && right_bal
  end

  def rebalance(node = root)
    data = inorder(node)
    mid = data.length / 2
    node.value = data[mid]
    node.left_child = build_tree(data[0...mid])
    node.right_child = build_tree(data[mid + 1..])
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end
