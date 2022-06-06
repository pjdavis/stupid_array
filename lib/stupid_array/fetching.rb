# frozen_string_literal: true

class StupidArray
  ##
  # Methods for fetching from StupidArrays
  module Fetching
    ##
    # Returns elements from self; does not modify self.
    #
    # @overload [](index)
    #   @param index [Integer]
    #   @return [Object, nil]
    # @overload [](start, length)
    #   @param start [Integer]
    #   @param length [Integer]
    #   @return [Object, nil]
    # @overload [](range)
    #   @param range [Range]
    #   @return [Object, nil]
    # @overload [](aseq)
    #   @param aseq [Enumerator::ArithmeticSequence]
    #   @return [Object, nil]
    #
    # @example When a single Integer argument index is given, returns the element at offset index:
    #   a = StupidArray.new([:foo, 'bar', 2])
    #   a[0] # => :foo
    #   a[2] # => 2
    #   a # => [:foo, "bar", 2]
    #
    # @example If index is negative, counts relative to the end of self:
    #   a = StupidArray.new([:foo, 'bar', 2])
    #   a[-1] # => 2
    #   a[-2] # => "bar"
    #
    # @example If index is out of range, returns nil.
    #   a = StupidArray.new([:foo, 'bar', 2])
    #   a[10] # => nil
    #   a[-9] # => nil
    #
    # @example When two Integer arguments start and length are given, returns a new StupidArray of size length containing successive elements beginning at offset start:
    #   a = StupidArray.new([:foo, 'bar', 2])
    #   a[0, 2] # => [:foo, "bar"]
    #   a[1, 2] # => ["bar", 2]
    #
    # @example If start + length is greater than self.length, returns all elements from offset start to the end:
    #   a = StupidArray.new([:foo, 'bar', 2])
    #   a[0, 4] # => [:foo, "bar", 2]
    #   a[1, 3] # => ["bar", 2]
    #   a[2, 2] # => [2]
    #
    # @example If start == self.size and length >= 0, returns a new empty StupidArray.
    #   a = StupidArray.new([:foo, 'bar', 2])
    #   a[3, 1] # => []
    #
    # @example If length is negative, returns nil.
    #   a = StupidArray.new([:foo, 'bar', 2])
    #   a[3, -1] # => nil
    #
    # @example When a single Range argument range is given, treats range.min as start above and range.size as length above:
    #   a = StupidArray.new([:foo, 'bar', 2])
    #   a[0..1] # => [:foo, "bar"]
    #   a[1..2] # => ["bar", 2]
    #
    # @example Special case: If range.start == a.size, returns a new empty StupidArray.
    #   a = StupidArray.new([:foo, 'bar', 2])
    #   a[3..4] # => []
    #
    # @example If range.end is negative, calculates the end index from the end:
    #   a = StupidArray.new([:foo, 'bar', 2])
    #   a[0..-1] # => [:foo, "bar", 2]
    #   a[0..-2] # => [:foo, "bar"]
    #   a[0..-3] # => [:foo]
    #
    # @example If range.start is negative, calculates the start index from the end:
    #   a = StupidArray.new([:foo, 'bar', 2])
    #   a[-1..2] # => [2]
    #   a[-2..2] # => ["bar", 2]
    #   a[-3..2] # => [:foo, "bar", 2]
    #
    # @example If range.start is larger than the StupidArray size, returns nil.
    #   a = StupidArray.new([:foo, 'bar', 2])
    #   a[4..1] # => nil
    #   a[4..0] # => nil
    #   a[4..-1] # => nil
    #
    # @example When a single Enumerator::ArithmeticSequence argument aseq is given, returns an StupidArray of elements corresponding to the indexes produced by the sequence.
    #   a = StupidArray.new(['--', 'data1', '--', 'data2', '--', 'data3'])
    #   a[(1..).step(2)] # => ["data1", "data2", "data3"]
    #
    # @example Unlike slicing with range, if the start or the end of the arithmetic sequence is larger than array size, throws RangeError.
    #   a = StupidArray.new(['--', 'data1', '--', 'data2', '--', 'data3'])
    #   a[(1..11).step(2)]
    #   # RangeError (((1..11).step(2)) out of range)
    #   a[(7..).step(2)]
    #   # RangeError (((7..).step(2)) out of range)
    #
    # @example If given a single argument, and its type is not one of the listed, tries to convert it to Integer, and raises if it is impossible:
    #   a = StupidArray.new([:foo, 'bar', 2])
    #   # Raises TypeError (no implicit conversion of Symbol into Integer):
    #   a[:foo]
    #
    # rubocop:disable Metrics/MethodLength
    def [](*args)
      case args.first
      when Integer
        index, len = args
        index = index.negative? ? negative_index(index) : index
        if len.nil?
          instance_variable_get("@stupid_item_#{index}")
        else
          return nil if len.negative? || index.negative? || index > size

          return_value = self.class.new
          return return_value if index == size && len >= 0

          finish = index + (len - 1) > last_index ? last_index : index + (len - 1)
          (finish).downto(index) do |i|
            return_value << instance_variable_get("@stupid_item_#{i}")
          end
          return_value.reverse

        end
      when Range
        range = args.first
        return self.class.new if range.begin == size

        if range.begin.positive? || range.begin.zero?
          if range.end.negative?
            finish = negative_index(range.end)
            self[range.begin, (size - finish)]
          else
            self[range.min, range.size]
          end
        else
          start = negative_index(range.begin)
          finish = range.end
          if start < finish
            self[start, (finish - start + 1)]
          else
            self.class.new
          end
        end
      when Enumerator::ArithmeticSequence
        enum = args.first
        raise RangeError if ![nil, Float::INFINITY].include?(enum.size) && (enum.last > last_index)

        return_value = self.class.new
        enum.each do |step|
          return return_value if step > last_index

          return_value << self[step]
        end
      else
        begin
          self[args.first.to_int]
        rescue StandardError
          raise TypeError
        end
      end
    end
    # rubocop:enable Metrics/MethodLength

    alias slice []

    private

    def fetch_args(args) end

    def stupid_elements
      instance_variable_set.grep(/@stupid_item_/)
    end

    def last_fetchable_index_for(index)
      index > last_index ? last_index : index
    end

    def last_index
      length - 1
    end

    def negative_index(index)
      length + index
    end
  end
end
