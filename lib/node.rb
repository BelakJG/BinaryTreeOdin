class Node
  include Comparable
  attr_accessor :value, :left_child, :right_child

  def initialize(value)
    @value = value
    @left_child = nil
    @right_child = nil
  end

  def leaf?
    left_child.nil? && right_child.nil?
  end
end
