# frozen_string_literal: true

class StupidArray
  module Comparing
    ##
    # Returns -1, 0, or 1 as self is less than, equal to, or greater than other_array. For each index i in self, evaluates result = self[i] <=> other_array[i].
    #
    # @param other [#<=>]
    # @return [-1,0,1]
    #
    # @example Returns -1 if any result is -1:
    #   StupidArray.new([0, 1, 2]) <=> StupidArray.new([0, 1, 3]) # => -1
    #
    # @example Returns 1 if any result is 1:
    #
    #   StupidArray.new([0, 1, 2]) <=> StupidArray([0, 1, 1]) # => 1
    #
    # @example When all results are zero:
    #   # Returns -1 if array is smaller than other_array:
    #   StupidArray.new([0, 1, 2]) <=> StupidArray.new([0, 1, 2, 3]) # => -1
    #
    #   # Returns 1 if array is larger than other_array:
    #   StupidArray.new([0, 1, 2]) <=> StupidArray.new([0, 1]) # => 1
    #
    #   # Returns 0 if array and other_array are the same size:
    #
    #   StupidArray.new([0, 1, 2]) <=> StupidArray.new([0, 1, 2]) # => 0
    def <=>(other)
      return nil unless other.respond_to?(:each)
      return length <=> other.length unless length == other.length

      0.upto(last_index) do |index|
        return nil if (self[index] <=> other[index]).nil?
        return (self[index] <=> other[index]) unless (self[index] <=> other[index]).zero?
      end
      0
    end

    ##
    # Returns true if both array.size == other_array.size and for each index i in array, array[i] == other_array[i]:
    # @param other [Array, StupidArray]
    # @return [Boolean]
    #
    # @example
    #   a0 = [:foo, 'bar', 2]
    #   a1 = [:foo, 'bar', 2.0]
    #   a1 == a0 # => true
    #   [] == [] # => true
    #
    # Otherwise, returns false.
    #
    # This method is different from method Array#eql?, which compares elements using Object#eql?.
    def ==(other)
      return false unless [Array, self.class].include?(other.class)
      return false unless length == other.length

      0.upto(other.length) do |index|
        return false unless self[index] == other[index]
      end
      true
    end

    ##
    # Returns true if self and other_array are the same size, and if, for each index i in self, self[i].eql? other_array[i]:
    #
    # @param other [Array, StupidArray]
    # @return [Boolean]
    #
    # @example
    #   a0 = [:foo, 'bar', 2]
    #   a1 = [:foo, 'bar', 2]
    #   a1.eql?(a0) # => true
    #
    # Otherwise, returns false.
    #
    # This method is different from method Array#==, which compares using method Object#==.
    def eql?(other)
      return false unless [Array, self.class].include?(other.class)
      return false unless length == other.length

      0.upto(other.length) do |index|
        return false unless self[index].eql?(other[index])
      end
      true
    end
  end
end
