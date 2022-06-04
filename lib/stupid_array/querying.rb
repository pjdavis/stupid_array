# frozen_string_literal: true

class StupidArray
  ##
  # Methods for querying StupidArrays
  module Querying
    ##
    # Returns true if all elements of self meet a given criterion.
    #
    # @overload all?
    # @overload all?(obj)
    #   @param obj
    # @overload all?
    #   @yield [element]
    #
    # @example With no block given and no argument, returns true if self contains only truthy elements, false otherwise:
    #   StupidArray.new([1, "yes", :foo]).all? # => true
    #   StupidArray.new([0, nil, 2]).all? # => false
    #   StupidArray.new.all? # => true
    #
    # @example With a block given and no argument, calls the block with each element in self; returns true if the block returns only truthy values, false otherwise:
    #   StupidArray.new([0,1,2]).all? { |element| element < 3 } # => true
    #   StupidArray.new([0,1,2]).all? { |element| element < 2 } # => false
    #
    # @example if arugment obj is given, returns true if obj.=== every element, false otherwise:
    #   StupidArray.new(['food', 'fool', 'foot']).all?(/foo/) # => true
    #   StupidArray.new(['food', 'drink']).all?(/bar/) # => false
    #   StupidArray.new([]).all?(/foo/) # => true
    #   StupidArray.new([0, 0, 0]).all?(0) # => true
    #   StupidArray.new([0, 1, 2]).all?(1) # => false
    def all?(obj = nil, &block)
      return true if empty?

      if obj.nil?
        if block_given?
          each do |element|
            return false unless block.call(element)
          end
          return true
        end
        each do |element|
          return false unless element
        end
      else
        warn("warning: given block not used") if block_given?
        each do |element|
          return false unless equivalent_object_compare(element, obj)
        end
      end

      true
    end

    ##
    # Returns true if any element of self meets a given criterion.
    #
    # @overload any?
    # @overload any?(obj)
    #   @param obj
    # @overload any?
    #   @yield [element]
    #
    # @example With no block given and no argument, returns true if self has any truthy element, false otherwise:
    #   StupidArray.new([nil, false, 0]) # => true
    #   StupidArray.new([nil, false]) # => false
    #   StupidArray.new.any? # => false
    #
    # @example With a block given and no argument, calls the block with each element in self; returns true if the block returns any truthy value, false otherwise:
    #   StupidArray.new([0,1,2]).any? {|element| element > 1 } # => true
    #   StupidArray.new([0,1,2]).any? {|element| element > 2 } # => false
    #
    # @example If argument obj is given, returns true if obj.=== any element, false otherwise:
    #   StupidArray.new(['food', 'drink']).any?(/foo/) # => true
    #   StupidArray.new(['food', 'drink']).any?(/bar/) # => false
    #   StupidArray.new.any(/foo/) # => false
    #   StupidArray.new([0,1,2]).any?(1) # => true
    #   StupidArray.new([0,1,2]).any?(3) # => false
    def any?(obj = nil, &block)
      return false if empty?

      if obj.nil?
        if block_given?
          each do |element|
            return true if block.call(element)
          end
          return false
        end
        each do |element|
          return true if element
        end
      else
        warn("warning: given block not used") if block_given?
        each do |element|
          return true if equivalent_object_compare(element, obj)
        end
      end

      false
    end

    ##
    # Returns a count of specified elements.
    # With argument obj and a block given, issues a warning, ignores the block, and returns the count of elements == to obj:
    #
    # @overload count
    #   @return [Integer]
    # @overload count(obj)
    #   @param(obj)
    #   @return [Integer]
    # @overload count
    #   @yield [element]
    #   @return [Integer]
    #
    # @example With no argument and no block, returns the count of all elements:
    #   StupidArray.new([0, 1, 2]).count # => 3
    #   StupidArray.new([]).count # => 0
    #
    # @example With argument obj, returns the count of elements == to obj:
    #   StupidArray.new([0, 1, 2, 0.0]).count(0) # => 2
    #   StupidArray.new([0, 1, 2]).count(3) # => 0
    #
    # @example With no argument and a block given, calls the block with each element; returns the count of elements for which the block returns a truthy value:
    #   StupidArray.new([0, 1, 2, 3]).count {|element| element > 1} # => 2
    #
    def count(obj = nil, &block)
      return 0 if empty?
      return length if obj.nil? && !block_given?

      match_count = 0

      if obj.nil?
        each do |element|
          match_count += 1 if block.call(element)
        end
      else
        warn("warning: given block not used") if block_given?
        each do |element|
          match_count += 1 if equivalent_object_compare_loose(element, obj)
        end
      end
      match_count
    end

    ##
    # Returns true if self contains no elements.
    #
    # @return [Boolean]
    def empty?
      stupid_elements.empty?
    end

    ##
    # Returns the integer hash value for self.
    #
    # @return [Integer]
    #
    # @example Two arrays with the same content will have the same hash code (and will compare using eql?):
    #   StupidArray.new([0, 1, 2]).hash == StupidArray.new([0, 1, 2]).hash # => true
    #   StupidArray.new([0, 1, 2]).hash == StupidArray.new([0, 1, 3]).hash # => false
    def hash
      value = Support::XXhash32.new(Process.pid)
      each do |element|
        value.update(element.hash.to_s)
      end
      value.digest
    end

    ##
    # Returns true if the given object is present in self (using ==), otherwise
    # returns false.
    #
    # @return [Boolean]
    def include?(object)
      each do |element|
        return true if element == object
      end
      false
    end

    ##
    # Returns the index of a specified element.
    # StupidArray#find_index is an alias for StupidArray#index.
    #
    # @overload index
    #   @return [Enumerator]
    # @overload index(obj)
    #   @param obj
    #   @return [Integer, nil]
    # @overload index
    #   @yield [element]
    #   @return [Integer, nil]
    #
    # @example When argument object is given but no block, returns the index of the first element element for which object == element:
    #   a = StupidArray.new([:foo, 'bar', 2, 'bar'])
    #   a.index('bar') # => 1
    #
    #   # Returns nil if no such element found.
    #
    # @example When both argument object and a block are given, calls the block with each successive element; returns the index of the first element for which the block returns a truthy value:
    #
    #   a = StupidArray.new([:foo, 'bar', 2, 'bar'])
    #   a.index {|element| element == 'bar' } # => 1
    #
    #   # Returns nil if the block never returns a truthy value.
    #
    # @example When neither an argument nor a block is given, returns a new Enumerator:
    #
    #   a = StupidArray.new([:foo, 'bar', 2])
    #   e = a.index
    #   e # => #<Enumerator: [:foo, "bar", 2]:index>
    #   e.each {|element| element == 'bar' } # => 1
    def index(obj = nil, &block)
      return to_enum if obj.nil? && !block_given?

      position = 0

      if obj.nil?
        each do |element|
          return position if block.call(element)

          position += 1
        end
      else
        warn("warning: given block not used") if block_given?
        each do |element|
          return position if equivalent_object_compare_loose(element, obj)

          position += 1
        end
      end
      nil
    end

    alias find_index index
    ##
    # Returns the number of elements in a StupidArray
    #
    # @return [Integer] the number of elements in the StupidArray
    def length
      return 0 if stupid_elements.empty?

      stupid_elements.map { |stupid_element| stupid_element[/@stupid_item_(\d*)/, 1].to_i }.max + 1
    end

    alias size length

    ##
    # Returns true if no element of self meet a given criterion
    #
    # @overload none?
    # @overload none?(obj)
    #   @param obj
    # @overload none?
    #   @yield [element]
    #
    # @example With no block given and no argument, returns true if self has no truthy elements, false otherwise:
    #   StupidArray.new([nil, false]).none? # => true
    #   StupidArray.new([nil, 0, false]).none? # => false
    #   StupidArray.new().none? # => true
    #
    # @example With a block given and no argument, calls the block with each element in self; returns true if the block returns no truthy value, false otherwise:
    #   StupidArray.new([0, 1, 2]).none? {|element| element > 3 } # => true
    #   StupidArray.new([0, 1, 2]).none? {|element| element > 1 } # => false
    #
    # @example If argument obj is given, returns true if obj.=== no element, false otherwise:
    #   StupidArray.new(['food', 'drink']).none?(/bar/) # => true
    #   StupidArray.new(['food', 'drink']).none?(/foo/) # => false
    #   StupidArray.new([]).none?(/foo/) # => true
    #   StupidArray.new([0, 1, 2]).none?(3) # => true
    #   StupidArray.new([0, 1, 2]).none?(1) # => false
    def none?(obj = nil, &block)
      return true if empty?

      if obj.nil?
        if block_given?
          each do |element|
            return false if block.call(element)
          end
          return true
        end
        each do |element|
          return false if element
        end
      else
        warn("warning: given block not used") if block_given?
        each do |element|
          return false if equivalent_object_compare(element, obj)
        end
      end

      true
    end

    ##
    # Returns true if exactly one element of self meets a given criterion.
    #
    # @overload one?
    # @overload one?(obj)
    #   @param obj
    # @overload one?
    #   @yield [element]
    #
    # @example With no block given and no argument, returns true if self has exactly one truthy element, false otherwise:
    #   StupidArray.new([nil, 0]).one? # => true
    #   StupidArray.new([0, 0]).one? # => false
    #   StupidArray.new([nil, nil]).one? # => false
    #   StupidArray.new([]).one? # => false
    #
    # @example With a block given and no argument, calls the block with each element in self; returns true if the block a truthy value for exactly one element, false otherwise:
    #   StupidArray.new([0, 1, 2]).one? {|element| element > 0 } # => false
    #   StupidArray.new([0, 1, 2]).one? {|element| element > 1 } # => true
    #   StupidArray.new([0, 1, 2]).one? {|element| element > 2 } # => false
    #
    # @example If argument obj is given, returns true if obj.=== exactly one element, false otherwise:
    #   StupidArray.new([0, 1, 2]).one?(0) # => true
    #   StupidArray.new([0, 0, 1]).one?(0) # => false
    #   StupidArray.new([1, 1, 2]).one?(0) # => false
    #   StupidArray.new(['food', 'drink']).one?(/bar/) # => false
    #   StupidArray.new(['food', 'drink']).one?(/foo/) # => true
    #   StupidArray.new([]).one?(/foo/) # => false
    def one?(obj = nil, &block)
      return false if empty?

      result = false

      if obj.nil?
        if block_given?
          each do |element|
            next unless block.call(element)
            return false if result

            result = true
          end
          return result
        end
        each do |element|
          next unless element
          return false if result

          result = true
        end
      else
        warn("warning: given block not used") if block_given?
        each do |element|
          next unless equivalent_object_compare(element, obj)
          return false if result

          result = true
        end
      end
      result
    end

    ##
    # Returns the index of the last element for which object == element.
    #
    # @overload rindex
    #   @return [Enumerator]
    # @overload rindex(obj)
    #   @param obj
    #   @return [Integer, nil]
    # @overload rindex
    #   @yield [element]
    #   @return [Integer, nil]
    #
    # @example When argument object is given but no block, returns the index of the last such element found:
    #   a = StupidArray.new([:foo, 'bar', 2, 'bar'])
    #   a.rindex('bar') # => 3
    #
    #   # Returns nil if no such object found.
    #
    # @example When a block is given but no argument, calls the block with each successive element; returns the index of the last element for which the block returns a truthy value:
    #
    #   a = StupidArray.new([:foo, 'bar', 2, 'bar'])
    #   a.rindex {|element| element == 'bar' } # => 3
    #
    #   # Returns nil if the block never returns a truthy value.
    #
    # @example When neither an argument nor a block is given, returns a new Enumerator:
    #   a = StupidArray.new([:foo, 'bar', 2, 'bar'])
    #   e = a.rindex
    #   e # => #<Enumerator: [:foo, "bar", 2, "bar"]:rindex>
    #   e.each {|element| element == 'bar' } # => 3
    def rindex(obj = nil, &block)
      return to_enum if obj.nil? && !block_given?

      position = length - 1

      if obj.nil?
        reverse.each do |element|
          return position if block.call(element)

          position -= 1
        end
      else
        warn("warning: given block not used") if block_given?
        reverse.each do |element|
          return position if equivalent_object_compare_loose(element, obj)

          position -= 1
        end
      end
      nil
    end

    private

    def to_enum
      Enumerator.new do |yielder|
        each do |element|
          yielder << element
        end
      end
    end

    def equivalent_object_compare(element, obj)
      if obj.is_a?(Regexp)
        obj.match(element)
      else
        # rubocop:disable Style/CaseEquality
        element === obj
        # rubocop:enable Style/CaseEquality
      end
    end

    def equivalent_object_compare_loose(element, obj)
      if obj.is_a?(Regexp)
        obj.match(element)
      else
        element == obj
      end
    end
  end
end
