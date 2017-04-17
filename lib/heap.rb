require 'byebug'
class BinaryMinHeap
  def initialize(&prc)
    @prc = prc || Proc.new { |el1, el2| el1 <=> el2 }
    @store = []
  end

  def count
    @store.length
  end

  def extract
    @store[0], @store[-1] = @store[-1], @store[0]
    pop = @store.pop

    BinaryMinHeap.heapify_down(@store, 0, &@prc)
    pop
  end

  def peek
    @store.first
  end

  def push(val)
    @store << val
    BinaryMinHeap.heapify_up(@store, count - 1, &@prc)
  end

  protected
  attr_accessor :prc, :store

  public
  def self.child_indices(len, parent_index)
    child_1 = 2 * parent_index + 1
    child_2 = 2 * parent_index + 2

    if len <= child_1
      []
    elsif len <= child_2
      [child_1]
    else
      [child_1, child_2]
    end
  end

  def self.parent_index(child_index)
    raise "root has no parent" if child_index == 0
    (child_index - 1) / 2
  end

  def self.min_child(array, parent_idx, len, &prc)
    child = BinaryMinHeap.child_indices(len, parent_idx)
    case child.length
    when 0 then nil
    when 1 then child.first
    else prc.call(array[child[0]], array[child[1]]) == -1 ? child[0] : child[1]
    end
  end

  def self.heapify_down(array, parent_idx, len = array.length, &prc)
    prc ||= Proc.new { |el1, el2| el1 <=> el2 }

    child_idx = BinaryMinHeap.min_child(array, parent_idx, len, &prc)

    while child_idx
      if prc.call(array[parent_idx], array[child_idx]) == 1
        array[parent_idx], array[child_idx] = array[child_idx], array[parent_idx]

        parent_idx = child_idx
        child_idx = BinaryMinHeap.min_child(array, parent_idx, len, &prc)
      else
        return array
      end
    end

    array
  end

  def self.heapify_up(array, child_idx, len = array.length, &prc)
    prc ||= Proc.new { |el1, el2| el1 <=> el2 }
    while child_idx > 0
      parent_idx = BinaryMinHeap.parent_index(child_idx)

      if prc.call(array[parent_idx], array[child_idx]) == 1
        array[parent_idx], array[child_idx] = array[child_idx], array[parent_idx]

        child_idx = parent_idx
      else
        return array
      end
    end

    array
  end
end
