require 'byebug'
require_relative "heap"

class Array
  def heap_sort!
    prc = Proc.new { |el1, el2| el2 <=> el1 }

    (1..self.length).each do |i|
      BinaryMinHeap.heapify_up(self, i - 1, i, &prc)
    end

    (self.length - 1).downto(0).each do |i|
      self[0], self[i] = self[i], self[0]
      BinaryMinHeap.heapify_down(self, 0, i, &prc)
    end

    self
  end
end
