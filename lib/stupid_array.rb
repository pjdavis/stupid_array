# frozen_string_literal: true

require_relative "stupid_array/version"

class StupidArray
  include Enumerable

  class Error < StandardError; end

  class ArgumentError < Error; end

  class IndexOutOfRangeError < Error; end

  def initialize(argc = nil, argv = nil, &block)
    if [Array, self.class].include?(argc.class)
      argc.each do |element|
        self << element
      end
      return
    end

    if block_given?
      if argc.is_a?(Numeric)
        0.upto(argc - 1) do
          self << block.call
        end
        return
      else
        return
      end
    end

    if argc.is_a?(Numeric)
      0.upto(argc - 1) do
        push(argv.nil? ? nil : argv)
      end
    end
  end

  def push(element)
    instance_variable_set("@stupid_item_#{length}", element)
    self
  end

  alias << push
  alias append push

  def length
    return 0 if stupid_elements.empty?

    stupid_elements.map { |stupid_element| stupid_element[/@stupid_item_(\d*)/, 1].to_i }.max + 1
  end

  alias size length

  def [](index, length = nil)
    if length.nil?
      if index.is_a?(Range)
        start = index.first
        last = index.exclude_end? ? index.last - 1 : index.last
        finish = last > last_index ? last_index : last
        return_value = StupidArray.new
        finish.downto(start) do |i|
          return_value << instance_variable_get("@stupid_item_#{i}")
        end
        return return_value.reverse
      else
        return instance_variable_get("@stupid_item_#{index.negative? ? negative_index(index) : index }")
      end
    else
      return nil if length.negative? || index > last_index

      start = index.negative? ? negative_index(index) : index
      return nil if start.negative?

      finish = (start + (length - 1) > last_index) ? last_index : start + (length - 1)
      return_value = self.class.new
      finish.downto(start) do |i|
        return_value << instance_variable_get("@stupid_item_#{i}")
      end
      return return_value.reverse
    end
  end

  alias at []
  alias slice []

  def []=(index, length = nil, value)
    if index.is_a?(Range)
      a_value = [self.class, Array].include?(value.class) ? value : self.class.new(1, value)
      new_sa = self.class.new
      if index.exclude_end?
        new_sa += self[0..(index.last - 1)] unless index.first.zero?

        return value
      else
        return value
      end
    end
    if length.nil?
      if index.negative? && index.abs > self.length
        raise IndexOutOfRangeError.new("index #{index} too small for array; minimum: -#{self.length}")
      end
      instance_variable_set("@stupid_item_#{index.negative? ? negative_index(index) : index }", value)
    else
      raise IndexOutOfRangeError.new("negative length (#{length})") if length.negative?

      a_value = [self.class, Array].include?(value.class) ? value : self.class.new(1, value)
      new_sa = self.class.new
      if index.positive? || index.zero?
        new_sa += self[0..(index - 1)] unless index.zero?
        new_sa += a_value
        new_sa += self[(index + length)..last_index]
      else
        new_sa += self[0..(negative_index(index) - 1)]
        new_sa += a_value
        new_sa += self[(negative_index(index) + length)..last_index]
      end
      self.clear
      new_sa.each { |element| self << element }
      value
    end
  end

  def &(other)
    return_value = self.class.new
    self.each do |element|
      if other.include?(element) && !return_value.include?(element)
        return_value << element
      end
    end
    other.each do |element|
      if self.include?(element) && !return_value.include?(element)
        return_value << element
      end
    end
    return_value
  end

  def <=>(other)
    return nil unless other.respond_to?(:each)
    return self.length <=> other.length unless self.length == other.length

    0.upto(last_index) do |index|
      return (self[index] <=> other[index]) unless (self[index] <=> other[index]) == 0
    end
    0
  end

  def *(times)
    return self.join(times) if times.is_a?(String)

    return_value = self.class.new
    1.upto(times) do
      return_value = return_value + self
    end
    return_value
  end

  def |(other)
    StupidArray.new((self + other).uniq)
  end

  alias union |

  def dig(*elements)
    element, *tail = elements
    if tail.empty?
      self[element]
    else
      self[element].dig(*tail)
    end
  end

  def join(seperator = nil)
    return String.new if length == 0
    return self.first.to_s if length == 1

    seperator = "" if seperator.nil?
    string = String.new
    0.upto(last_index - 1) do |index|
      if self[index].respond_to?(:join)
        string << self[index].join(seperator)
      else
        string << self[index].to_s
      end
      string << seperator
    end
    string << (self.last.respond_to?(:join) ? self.last.join(seperator) : self.last.to_s)
    string
  end

  def to_s
    str = String.new("[")
    0.upto(last_index) do |index|
      str << (self[index].nil? ? "nil" : self[index].to_s)
      str << ", " unless index == last_index
    end
    str << "]"
    str
  end

  def inspect
    to_s
  end

  def first
    self[0]
  end

  def last
    return nil if self.empty?
    self[last_index]
  end

  def ranged(index, length)
    return nil if length <= 0

    return_length = length > self.length ? self.length : length
    return_object = self.class.new
    enum = (index < length ? index.upto(return_length) : index.downto(return_length))
    enum.each do |i|
      return_object << self[i]
    end
    return_object
  end

  def sliced(index, length)
    return nil if length <= 0

    start = index.negative? ? self.length + index : index
    finish = start + length > self.length ? self.length - 1 : start + length
    return_value = StupidArray.new
    start.upto(finish - 1) do |i|
      return_value << self[i]
    end
    return_value
  end

  def slice!(index, length = nil)
    if length.nil?
      if index.is_a?(Range)
        start = index.first
        finish = index.exclude_end? ? index.last - 1 : index.last
        return_value = StupidArray.new
        finish.downto(start) do |i|
          return_value << delete_at(i)
        end
        return return_value.reverse
      else
        self.delete_at(index.negative? ? negative_index(index) : index)
      end
    else
      return nil if length.negative? || index > last_index

      start = index.negative? ? negative_index(index) : index
      return nil if start.negative?

      finish = (start + (length - 1) > last_index) ? last_index : start + (length - 1)
      return_value = StupidArray.new
      finish.downto(start) do |i|
        return_value << delete_at(i)
      end
      return return_value.reverse
    end
  end

  def fetch(index)
    raise IndexOutOfRangeError if index > last_index
    self[index]
  end

  def ==(other)
    return false unless [Array, self.class].include?(other.class)
    return false unless length == other.length

    0.upto(other.length) do |index|
      return false unless self[index] == other[index]
    end
    true
  end

  def each(&block)
    0.upto(length - 1).each do |index|
      block.call(self[index])
    end
  end

  def each_index(&block)
    0.upto(last_index) do |index|
      block.call(index)
    end
  end

  def +(other)
    copy = self.dup
    other.each do |element|
      copy << element
    end
    copy
  end

  alias concat +

  def -(other)
    copy = self.dup
    other.each do |element|
      (copy.length - 1).downto(0) do |index|
        if copy[index].hash.eql?(element.hash)
          copy.delete_at(index)
        end
      end
    end
    copy
  end

  def insert(index, *elements)
    (self.length - 1).downto(index) do |i|
      instance_variable_set("@stupid_item_#{i + elements.size}", self[i])
    end
    elements.each_with_index do |element, i|
      instance_variable_set("@stupid_item_#{index + i}", element)
    end
    self
  end

  def empty?
    stupid_elements.empty?
  end

  def delete_at(index)
    return nil if index > last_index

    element = self[index]
    index.upto(self.length - 1) do |i|
      instance_variable_set("@stupid_item_#{i}", self[i + 1])
    end
    remove_instance_variable("@stupid_item_#{self.length - 1}")
    element
  end

  def delete(element, &block)
    found = false
    (self.length - 1).downto(0) do |index|
      if self[index] == element
        delete_at(index)
        found = true
      end
    end
    if found
      element
    else
      block_given? ? block.call : nil
    end
  end

  def shift
    return nil if empty?

    delete_at(0)
  end

  def pop(elements = nil)
    return nil if empty?
    return delete_at(self.length - 1) if elements.nil?
    raise ArgumentError.new("negative StupidArray size") if elements.negative?

    if elements >= self.length
      return_value = StupidArray.new(self)
      clear
      return return_value
    end

    return_value = self[self.length - elements, elements]
    (self.length - 1).downto(self.length - elements) do |index|
      delete_at(index)
    end
    return_value
  end

  def sample(count = nil, random: nil)
    if count.nil?
      element_index = (random.nil? ? rand(last_index) : random.rand(last_index))
      self.fetch(element_index)
    else
      count = (count > length ? length : count)
      pool = self.dup
      return_value = self.class.new
      count.times do |num|
        element_index = (random.nil? ? rand(pool.length - 1) : random.rand(pool.length - 1))
        element_index = 0 if element_index < 1
        return_value << pool.delete_at(element_index)
      end
      return_value
    end
  end

  def shuffle
    StupidArray.new(self.sample(self.length))
  end

  def shuffle!
    self.sample(self.length).each_with_index do |element, index|
      self[index] = element
    end
    self
  end

  def drop(elements)
    raise ArgumentError.new("attempt to drop negative size") if elements.to_i.negative?
    return self.class.new if elements >= self.length

    start = self.length - elements
    finish = last_index
    self[start, finish]
  end

  def clear
    (length - 1).downto(0) do |index|
      delete_at(index)
    end
    self
  end

  def reverse
    return_value = self.class.new
    self.reverse_each do |element|
      return_value << element
    end
    return_value
  end

  def reverse!
    tmp = self.class.new(self)
    self.clear
    tmp.reverse_each do |element|
      self << element
    end
    self
  end

  def unshift(element)
    (self.length - 1).downto(0) do |index|
      instance_variable_set("@stupid_item_#{index + 1}", self[index])
    end
    instance_variable_set("@stupid_item_0", element)
    self
  end

  private

  def stupid_elements
    instance_variables.select { |instance_variable| instance_variable.match?(/@stupid_item_/) }
  end

  def last_index
    length - 1
  end

  def negative_index(index)
    length + index
  end
end