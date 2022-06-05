# frozen_string_literal: true

RSpec.describe StupidArray do
  it "has a version number" do
    expect(StupidArray::VERSION).not_to be nil
  end

  context "initialization" do
    context "create from array" do
      it "has the same elements as the array" do
        a = [1, 2, 3]
        sa = StupidArray.new(a)
        0.upto(a.size) do |i|
          expect(sa[i]).to eq a[i]
        end
      end
    end

    context "create with number of elements" do
      it "contains the number of elements specified" do
        sa = StupidArray.new(3)
        expect(sa.length).to eq 3
      end
    end

    context "create with number of initialized elements" do
      it "contains the number of elements specified, initialized to the object specified" do
        sa = StupidArray.new(3, true)
        0.upto(sa.length - 1) do |index|
          expect(sa[index]).to be true
        end
      end

      it "modifies other elements in the Array" do
        sa = StupidArray.new(2, [])
        sa[0] << 1
        expect(sa[1]).to eq [1]
      end
    end

    context "create with number of block-initialized elements" do
      it "contains the number of elements specified, initialized to calling the block of the object specified" do
        sa = StupidArray.new(3) { [] }
        0.upto(sa.length - 1) do |index|
          expect(sa[index]).to eq []
        end
      end

      it "does not modify other elements in the array" do
        sa = StupidArray.new(2) { [] }
        sa[0] << "hello"
        expect(sa[1]).to eq []
      end
    end
  end

  context "adding elements" do
    context "#|" do
      it "returns a union of 2 StupidArrays" do
        sa = StupidArray.new([1, 2, 3])
        sa2 = StupidArray.new([4, 5, 6])
        expect(sa | sa2).to eq [1, 2, 3, 4, 5, 6]
      end

      it "is aliased as #union" do
        sa = StupidArray.new([1])
        sa2 = StupidArray.new([2])
        expect(sa.union(sa2)).to eq [1, 2]
      end
    end

    context "#push" do
      it "adds an element" do
        sa = StupidArray.new
        sa.push(1)
        expect(sa.length).to eq 1
      end
      it "returns the StupidArray" do
        sa = StupidArray.new
        expect(sa.push(1)).to eq [1]
      end
      it "aliases #append" do
        sa = StupidArray.new
        expect(sa.append(1)).to eq [1]
      end
    end

    context "#<<" do
      it "adds an element" do
        sa = StupidArray.new
        sa << 1
        expect(sa.length).to eq 1
      end
    end

    context "#+" do
      it "adds another StupidArray" do
        sa = StupidArray.new(3)
        other_sa = StupidArray.new(3)
        expect((sa + other_sa).length).to eq 6
      end

      it "adds another Array" do
        sa = StupidArray.new(3)
        array = Array.new(3)
        expect((sa + array).length).to eq 6
      end

      it "adds another Enumerable" do
        sa = StupidArray.new(3)
        range = 1..3
        expect((sa + range).length).to eq 6
      end

      it "leaves the original StupidArray" do
        sa = StupidArray.new(3)
        (sa + StupidArray.new(3))
        expect(sa.length).to eq 3
      end

      it "is aliased to concat" do
        sa = StupidArray.new(3)
        sa2 = StupidArray.new(3)
        expect(sa.concat(sa2).length).to eq 6
      end
    end

    context "#-" do
      it "removes elements from other StupidArray" do
        sa = StupidArray.new([1, 2, 3, 4])
        sa2 = StupidArray.new([1, 2])
        expect(sa - sa2).to eq [3, 4]
      end

      it "leaves the original StupidArray" do
        sa = StupidArray.new([1, 2, 3, 4])
        sa2 = StupidArray.new([1])
        (sa - sa2)
        expect(sa.length).to eq 4
      end
    end

    context "#unshift" do
      it "adds elements to the beginning of the StupidArray" do
        sa = StupidArray.new([2, 3, 4])
        sa.unshift(1)
        expect(sa).to eq [1, 2, 3, 4]
      end

      it "returns the StupidArray" do
        sa = StupidArray.new([2, 3, 4])
        expect(sa.unshift(1)).to eq [1, 2, 3, 4]
      end
    end

    context "#insert" do
      it "inserts an element at the index" do
        sa = StupidArray.new([1, 2, 3])
        sa.insert(1, 5)
        expect(sa).to eq [1, 5, 2, 3]
      end

      it "inserts multiple elements at the index" do
        sa = StupidArray.new([1, 2, 3])
        sa.insert(1, 5, 6)
        expect(sa).to eq [1, 5, 6, 2, 3]
      end

      it "returns a StupidArray" do
        sa = StupidArray.new([1, 2, 3])
        expect(sa.insert(1, 5)).to eq [1, 5, 2, 3]
      end
    end
  end

  context "removing elements" do
    context "#delete_at" do
      it "removes an element" do
        sa = StupidArray.new([1, 2, 3])
        sa.delete_at(1)
        expect(sa.length).to eq 2
      end

      it "returns the removed element" do
        sa = StupidArray.new([1, 2, 3])
        expect(sa.delete_at(1)).to eq 2
      end

      it "keeps the other elements" do
        sa = StupidArray.new([1, 2, 3])
        sa.delete_at(1)
        expect(sa).to eq [1, 3]
      end
    end

    context "#shift" do
      it "removes the first element" do
        sa = StupidArray.new([1, 2, 3])
        sa.shift
        expect(sa).to eq [2, 3]
      end

      it "returns the first element" do
        sa = StupidArray.new([1, 2, 3])
        expect(sa.shift).to eq 1
      end

      it "returns nil if the StupidArray is empty" do
        sa = StupidArray.new
        expect(sa.shift).to be nil
      end
    end

    context "#delete" do
      it "removes the element from the StupidArray" do
        sa = StupidArray.new([1, 2, 3])
        sa.delete(3)
        expect(sa).to eq [1, 2]
      end

      it "returns the element deleted" do
        sa = StupidArray.new([1, 2, 3])
        expect(sa.delete(3)).to eq 3
      end

      it "returns nil if the element doesn't exist in the StupidArray" do
        sa = StupidArray.new([1, 2, 3])
        expect(sa.delete(6)).to be nil
      end

      it "returns the value of a block if the element doesn't exist in the StupidArray" do
        sa = StupidArray.new([1, 2, 3])
        expect(sa.delete(6) { "Not Found" }).to eq "Not Found"
      end
    end

    context "#pop" do
      it "removes the last element of the StupidArray" do
        sa = StupidArray.new([1, 2, 3])
        sa.pop
        expect(sa).to eq [1, 2]
      end

      it "returns the last element of the StupidArray" do
        sa = StupidArray.new([1, 2, 3])
        expect(sa.pop).to eq 3
      end

      it "when provided an argument, removes the last n elements of the StupidArray" do
        sa = StupidArray.new([1, 2, 3])
        sa.pop(2)
        expect(sa).to eq [1]
      end

      it "when provided an argument, returns a new StupidArray with the removed elements" do
        sa = StupidArray.new([1, 2, 3])
        expect(sa.pop(2)).to eq [2, 3]
      end

      it "raises an ArgumentError when provided a negative argument" do
        sa = StupidArray.new([1, 2, 3])
        expect { sa.pop(-2) }.to raise_error(StupidArray::ArgumentError)
      end

      it "empties the StupidArray if elements is larger than the StupidArray" do
        sa = StupidArray.new([1, 2, 3])
        sa.pop(10)
        expect(sa.empty?).to be true
      end

      it "returns the whole StupidArray if elements is larger than the StupidArray" do
        sa = StupidArray.new([1, 2, 3])
        expect(sa.pop(10)).to eq [1, 2, 3]
      end
    end

    context "clear" do
      it "clears the StupidArray" do
        sa = StupidArray.new([1, 2, 3])
        sa.clear
        expect(sa.empty?).to be true
      end

      it "returns an empty StupidArray" do
        sa = StupidArray.new([1, 2, 3])
        expect(sa.clear).to eq []
      end
    end

    context "#drop" do
      context "with a positive integer" do
        it "returns a StupidArray with n elements from the end of the StupidArray" do
          sa = StupidArray.new([1, 2, 3, 4])
          expect(sa.drop(2)).to eq [3, 4]
        end

        it "returns a StupidArray" do
          sa = StupidArray.new([1, 2, 3, 4])
          expect(sa.drop(2)).to be_a StupidArray
        end

        it "returns an empty StupidArray if you drop all elements" do
          sa = StupidArray.new([1, 2, 3, 4])
          expect(sa.drop(4)).to eq []
        end

        it "does not remove elements from the StupidArray" do
          sa = StupidArray.new([1, 2, 3, 4])
          sa.drop(2)
          expect(sa).to eq [1, 2, 3, 4]
        end
      end

      context "with a negative integer" do
        it "raises a StupidArray::ArgumentError" do
          sa = StupidArray.new([1, 2, 3])
          expect { sa.drop(-1) }.to raise_error StupidArray::ArgumentError
        end
      end
    end
  end

  context "retrieving elements" do
    context "#[]" do
      context "with a numeric argument" do
        it "retrieves the element at the index" do
          sa = StupidArray.new
          sa << 1
          expect(sa[0]).to eq 1
        end

        it "returns nil for outside of range index" do
          sa = StupidArray.new
          expect(sa[5]).to be nil
        end

        it "returns from the back of the StupidArray for negative indexes" do
          sa = StupidArray.new([1, 2, 3, 4])
          expect(sa[-1]).to eq 4
        end
      end

      context "with a range argument" do
        it "returns a range of elements" do
          sa = StupidArray.new([1, 2, 3, 4])
          expect(sa[1..3]).to eq [2, 3, 4]
        end

        it "returns a truncated range if the range goes beyond the length of the StupidArray" do
          sa = StupidArray.new([1, 2, 3, 4])
          expect(sa[2..6]).to eq [3, 4]
        end
      end

      context "with an index and a length" do
        it "returns a range of elements" do
          sa = StupidArray.new([1, 2, 3, 4])
          expect(sa[1, 3]).to eq [2, 3, 4]
        end

        it "allows negative index" do
          sa = StupidArray.new([1, 2, 3, 4, 5, 6])
          expect(sa[-3, 3]).to eq [4, 5, 6]
        end
      end

      context "#slice!" do
        context "with an index" do
          context "that is a negative number" do
            it "returns from the end of the StupidArray" do
              sa = StupidArray.new([1, 2, 3])
              expect(sa.slice!(-2)).to eq 2
            end
            it "removes the element from the StupidArray" do
              sa = StupidArray.new([1, 2, 3])
              sa.slice!(-2)
              expect(sa).to eq [1, 3]
            end
          end
          context "that is in range" do
            it "returns the element at the given index" do
              sa = StupidArray.new([1, 2, 3])
              expect(sa.slice!(1)).to eq 2
            end

            it "removes the element at the index from the array" do
              sa = StupidArray.new([1, 2, 3])
              sa.slice!(1)
              expect(sa).to eq [1, 3]
            end
          end
          context "that is out of range" do
            it "returns nil" do
              sa = StupidArray.new([1])
              expect(sa.slice!(5)).to be nil
            end
            it "leaves the StupidArray unchanged" do
              sa = StupidArray.new([1])
              sa.slice!(5)
              expect(sa).to eq [1]
            end
          end
        end
        context "with a Range" do
          context "with a regular Range" do
            it "returns the elements in the Range" do
              sa = StupidArray.new([1, 2, 3, 4, 5])
              expect(sa.slice!(1..3)).to eq [2, 3, 4]
            end
            it "removes the elements in the range" do
              sa = StupidArray.new([1, 2, 3, 4, 5])
              sa.slice!(1..3)
              expect(sa).to eq [1, 5]
            end
          end
          context "with an exclusive Range" do
            it "returns the elements in the Range" do
              sa = StupidArray.new([1, 2, 3, 4, 5])
              expect(sa.slice!(1...3)).to eq [2, 3]
            end
            it "removes the elements in the range" do
              sa = StupidArray.new([1, 2, 3, 4, 5])
              sa.slice!(1...3)
              expect(sa).to eq [1, 4, 5]
            end
          end
        end
        context "with a start and a length" do
          context "with an out of index start" do
            context "with a positive length" do
              it "returns nil" do
                sa = StupidArray.new([1, 2, 3, 4, 5])
                expect(sa.slice!(7, 2)).to be nil
              end
              it "leaves the StupidArray as it is" do
                sa = StupidArray.new([1, 2, 3, 4, 5])
                sa.slice!(7, 2)
                expect(sa).to eq [1, 2, 3, 4, 5]
              end
            end
            context "with a negative length" do
              it "returns nil" do
                sa = StupidArray.new([1, 2, 3, 4, 5])
                expect(sa.slice!(7, -2)).to be nil
              end
              it "leaves the StupidArray as it is" do
                sa = StupidArray.new([1, 2, 3, 4, 5])
                sa.slice!(7, -2)
                expect(sa).to eq [1, 2, 3, 4, 5]
              end
            end
          end
          context "with a positive start" do
            context "with a positive length" do
              it "returns length elements starting at start" do
                sa = StupidArray.new([1, 2, 3, 4, 5])
                expect(sa.slice!(1, 3)).to eq [2, 3, 4]
              end
              it "removes the sliced elements" do
                sa = StupidArray.new([1, 2, 3, 4, 5])
                sa.slice!(1, 3)
                expect(sa).to eq [1, 5]
              end
            end
            context "with a negative length" do
              it "returns length elements starting at start" do
                sa = StupidArray.new([1, 2, 3, 4, 5])
                expect(sa.slice!(1, -3)).to be nil
              end
              it "removes the sliced elements" do
                sa = StupidArray.new([1, 2, 3, 4, 5])
                sa.slice!(1, -3)
                expect(sa).to eq [1, 2, 3, 4, 5]
              end
            end
          end
          context "with a negative start" do
            context "with a positive length" do
              context "when the length is within the StupidArray" do
                it "returns length elements starting at start" do
                  sa = StupidArray.new([1, 2, 3, 4, 5])
                  expect(sa.slice!(-4, 3)).to eq [2, 3, 4]
                end
                it "removes the sliced elements" do
                  sa = StupidArray.new([1, 2, 3, 4, 5])
                  sa.slice!(-4, 3)
                  expect(sa).to eq [1, 5]
                end
              end
              context "when the length is past the end of the StupidArray" do
                it "returns length elements starting at start" do
                  sa = StupidArray.new([1, 2, 3, 4, 5])
                  expect(sa.slice!(-4, 7)).to eq [2, 3, 4, 5]
                end
                it "removes the sliced elements" do
                  sa = StupidArray.new([1, 2, 3, 4, 5])
                  sa.slice!(-4, 7)
                  expect(sa).to eq [1]
                end
              end
            end
            context "with a negative length" do
              it "returns length elements starting at start" do
                sa = StupidArray.new([1, 2, 3, 4, 5])
                expect(sa.slice!(-4, -3)).to be nil
              end
              it "removes the sliced elements" do
                sa = StupidArray.new([1, 2, 3, 4, 5])
                sa.slice!(-4, -3)
                expect(sa).to eq [1, 2, 3, 4, 5]
              end
            end
            context "that is out of range" do
              it "returns length elements starting at start" do
                sa = StupidArray.new([1, 2, 3, 4, 5])
                expect(sa.slice!(-8, 3)).to be nil
              end
              it "removes the sliced elements" do
                sa = StupidArray.new([1, 2, 3, 4, 5])
                sa.slice!(-8, 3)
                expect(sa).to eq [1, 2, 3, 4, 5]
              end
            end
          end
        end
      end

      context "#dig" do
        it "extracts an element from a StupidArray" do
          sa = StupidArray.new([1, 2, 3])
          expect(sa[1]).to eq 2
        end

        it "returns nil if an element is nil" do
          sa = StupidArray.new([1, 2, 3])
          expect(sa[5]).to be nil
        end

        it "returns nested digs" do
          inner_sa = StupidArray.new([1, 2])
          sa = StupidArray.new([1, inner_sa])
          expect(sa.dig(1, 1)).to eq 2
        end

        it "returns nil if any element is nil" do
          inner_sa = StupidArray.new([1, 2])
          middle_sa = StupidArray.new([inner_sa, nil])
          sa = StupidArray.new([middle_sa, 2])
          expect(sa.dig(0, 1)).to be nil
        end
      end
    end

    context "#at" do
      it "returns the element at the index" do
        sa = StupidArray.new
        sa << 1
        expect(sa.at(0)).to eq 1
      end

      it "returns nil for outside the range index" do
        sa = StupidArray.new
        expect(sa.at(5)).to be nil
      end
    end

    context "#fetch" do
      it "returns the element at the index" do
        sa = StupidArray.new([1])
        expect(sa.fetch(0)).to eq 1
      end

      it "raises an IndexOutOfRange error if the index is out of range" do
        sa = StupidArray.new
        expect { sa.fetch(1) }.to raise_error StupidArray::IndexOutOfRangeError
      end
    end

    context "#first" do
      it "returns the first element" do
        sa = StupidArray.new([1, 2, 3])
        expect(sa.first).to eq 1
      end
      it "returns nil if StupidArray is empty" do
        sa = StupidArray.new
        expect(sa.first).to be nil
      end
    end

    context "#last" do
      it "returns the last element in the StupidArray" do
        sa = StupidArray.new([1, 2, 3])
        expect(sa.last).to eq 3
      end

      it "returns nil if StupidArray is empty" do
        sa = StupidArray.new
        expect(sa.last).to be nil
      end
    end

    context "#sample" do
      context "with no arguments" do
        it "returns a random element from a StupidArray" do
          srand(123)
          sa = StupidArray.new([1, 2, 3, 4, 5])
          expect(sa.sample).to eq 3
        end
      end
      context "with an integer argument" do
        it "returns n random elements from StupidArray" do
          srand(123)
          sa = StupidArray.new([1, 2, 3, 4, 5])
          expect(sa.sample(2)).to eq [3, 2]
        end

        it "returns the whole StupidArray shuffled if bigger than the StupidArray" do
          srand(123)
          sa = StupidArray.new([1, 2, 3, 4])
          expect(sa.sample(10)).to eq [3, 2, 1, 4]
        end
      end
      context "with a random number generator" do
        it "returns a random element based on the RNG" do
          rng = Class.new
          rng.define_singleton_method(:rand) { |_number| 1 }
          sa = StupidArray.new([1, 2, 3, 4, 5])
          expect(sa.sample(random: rng)).to eq 2
        end
      end
      context "with an integer and a random number generator" do
        it "returns a random element based on the RNG" do
          rng = Class.new
          rng.define_singleton_method(:rand) { |_number| 1 }
          sa = StupidArray.new([1, 2, 3, 4, 5])
          expect(sa.sample(2, random: rng)).to eq [2, 3]
        end
      end
    end

    context "#shuffle" do
      context "without rng" do
        it "returns the StupidArray shuffled" do
          srand(43)
          sa = StupidArray.new([1, 2, 3, 4, 5, 6])
          expect(sa.shuffle).to eq [5, 1, 3, 4, 2, 6]
        end
        it "returns a StupidArray" do
          srand(43)
          sa = StupidArray.new([1, 2, 3, 4, 5, 6])
          expect(sa.shuffle).to be_a StupidArray
        end
      end

      context "with rng" do
        it "returns the StupidArray shuffled based on the RNG" do
          rng = Class.new
          rng.define_singleton_method(:rand) { |_number| 1 }
          sa = StupidArray.new([1, 2, 3, 4, 5])
          expect(sa.shuffle).to eq [4, 2, 3, 1, 5]
        end
        it "returns a StupidArray" do
          rng = Class.new
          rng.define_singleton_method(:rand) { |_number| 1 }
          sa = StupidArray.new([1, 2, 3, 4, 5])
          expect(sa.shuffle).to be_a StupidArray
        end
      end
    end

    context "shuffle!" do
      context "without rng" do
        it "returns the StupidArray shuffled" do
          srand(43)
          sa = StupidArray.new([1, 2, 3, 4, 5, 6])
          expect(sa.shuffle!).to eq [5, 1, 3, 4, 2, 6]
        end
        it "shuffles the StupidArray in place" do
          srand(43)
          sa = StupidArray.new([1, 2, 3, 4, 5, 6])
          sa.shuffle!
          expect(sa).to eq [5, 1, 3, 4, 2, 6]
        end
      end
    end
  end

  context "iterating elements" do
    context "#each" do
      it "returns each element" do
        sa = StupidArray.new(3)
        sa.each do |element|
          expect(element).to be nil
        end
      end
    end

    context "#*" do
      context "with an integer" do
        it "repeats the elements n times" do
          sa = StupidArray.new([1])
          expect(sa * 3).to eq [1, 1, 1]
        end

        it "does the entire StupidArray for each n" do
          sa = StupidArray.new([1, 2])
          expect(sa * 2).to eq [1, 2, 1, 2]
        end
      end

      context "with a string" do
        it "joins the elements in teh StupidArray" do
          sa = StupidArray.new([1, 2, 3])
          expect(sa * ",").to eq "1,2,3"
        end
      end
    end

    context "#each_index" do
      it "returns each index" do
        sa = StupidArray.new(3)
        count = [0, 1, 2]
        sa.each_index do |i|
          expect(i).to eq count[i]
        end
      end
    end
  end

  context "comparing elements" do
    context "#&" do
      it "gets the intersection of the two StupidArrarys" do
        sa = StupidArray.new([1, 2, 3])
        sa2 = StupidArray.new([2, 3, 4])
        expect(sa & sa2).to eq [2, 3]
      end
      it "returns unique values from each array" do
        sa = StupidArray.new([1, 2, 2, 3])
        sa2 = StupidArray.new([2, 2, 3, 4])
        expect(sa & sa2).to eq [2, 3]
      end
      it "preserves order from original array" do
        sa = StupidArray.new([3, 2, 2, 1])
        sa2 = StupidArray.new([2, 2, 3, 4])
        expect(sa & sa2).to eq [3, 2]
      end
    end

    context "#<=>" do
      it "returns a -1 when StupidArray is smaller than other" do
        sa = StupidArray.new([1])
        sa2 = StupidArray.new([2])
        expect(sa <=> sa2).to eq(-1)
      end

      it "returns 0 when StupidArray is equal to other" do
        sa = StupidArray.new([1])
        sa2 = StupidArray.new([1])
        expect(sa <=> sa2).to eq 0
      end

      it "returns 1 when StupidArray is greater than other" do
        sa = StupidArray.new([2])
        sa2 = StupidArray.new([1])
        expect(sa <=> sa2).to eq 1
      end

      it "returns nil when other is not enumerable" do
        sa = StupidArray.new([1])
        other = 1
        expect(sa <=> other).to be nil
      end

      it "compares after end of StupidArray" do
        sa = StupidArray.new([1, 2])
        sa2 = StupidArray.new([1, 2, 3])
        expect(sa <=> sa2).to eq(-1)
      end

      it "compares after end of other" do
        sa = StupidArray.new([1, 2, 3])
        sa2 = StupidArray.new([1, 2])
        expect(sa <=> sa2).to eq 1
      end

      it "returns nil if elements can not be directly compared" do
        sa = StupidArray.new([1, 2])
        sa2 = StupidArray.new([1, :two])
        expect(sa <=> sa2).to be nil
      end
    end
  end

  context "checking the size of the StupidArray" do
  end

  context "modifying a StupidArray" do
    context "#[]=" do
      context "with an index" do
        context "with a positive index" do
          it "it sets the element at n to the value" do
            sa = StupidArray.new([1, 2, 3])
            sa[1] = 4
            expect(sa).to eq [1, 4, 3]
          end
          it "expands the StupidArray if set past the end" do
            sa = StupidArray.new([1, 2, 3])
            sa[10] = 4
            expect(sa.length).to eq 11
          end
          it "returns the value" do
            sa = StupidArray.new([1, 2, 3])
            expect(sa[1] = 4).to eq 4
          end
        end
        context "with a negative index" do
          it "sets the element at -n to the value" do
            sa = StupidArray.new([1, 2, 3])
            sa[-1] = 4
            expect(sa).to eq [1, 2, 4]
          end
          it "raises StupidArray::IndexOutOfRangeError if beyond the StupidArray" do
            sa = StupidArray.new([1, 2, 3])
            expect { sa[-10] = 4 }.to raise_error StupidArray::IndexOutOfRangeError
          end
          it "returns the value" do
            sa = StupidArray.new([1, 2, 3])
            expect(sa[-1] = 4).to eq 4
          end
        end
      end
      context "with a Range" do
        context "that is not exclusive" do
          context "with a positive start" do
            context "and a positive end" do
              it "replaces part of the StupidArray" do
                sa = StupidArray.new([1, 2, 3, 4, 5, 6])
                sa[1..3] = %w[a b]
                expect(sa).to eq [1, "a", "b", 5, 6]
              end
              it "returns the assigned value" do
                sa = StupidArray.new([1, 2, 3, 4, 5, 6])
                ret = sa[1..3] = %w[a b]
                expect(ret).to eq %w[a b]
              end
            end
            context "and a negative end" do
              it "replaces part of the StupidArray" do
                sa = StupidArray.new([1, 2, 3, 4, 5, 6])
                sa[1..-2] = %w[a b]
                expect(sa).to eq [1, "a", "b", 6]
              end
              it "returns the assigned value" do
                sa = StupidArray.new([1, 2, 3, 4, 5, 6])
                ret = sa[1..-2] = %w[a b]
                expect(ret).to eq %w[a b]
              end
            end
          end
          context "with a negative start" do
            context "and a postitive end" do
              xit "replaces part of the StupidArray" do
                sa = StupidArray.new([1, 2, 3, 4, 5, 6])
                sa[-1..4] = %w[a b]
                expect(sa).to eql
              end
              it "returns the assigned value"
            end
            context "and a negative end" do
              it "replaces part of the StupidArray"
              it "returns the assigned value"
            end
          end
        end
        context "that is exclusive" do
          context "with a positive start" do
            context "and a positive end" do
              it "replaces part of the StupidArray" do
                sa = StupidArray.new([1, 2, 3, 4, 5, 6])
                sa[1...3] = %w[a b]
                expect(sa).to eq [1, "a", "b", 4, 5, 6]
              end
              it "returns the assigned value" do
                sa = StupidArray.new([1, 2, 3, 4, 5, 6])
                ret = sa[1...3] = %w[a b]
                expect(ret).to eq %w[a b]
              end
            end
            context "and a negative end" do
              it "replaces part of the StupidArray" do
                sa = StupidArray.new([1, 2, 3, 4, 5, 6])
                sa[1...-3] = %w[a b]
                expect(sa).to eq [1, "a", "b", 4, 5, 6]
              end
              it "returns the assigned value" do
                sa = StupidArray.new([1, 2, 3, 4, 5, 6])
                ret = sa[1...-3] = %w[a b]
                expect(ret).to eq %w[a b]
              end
            end
          end
          context "with a negative start" do
            context "and a postitive end"
            context "and a negative end"
          end
        end
      end
      context "with a start and a length" do
        context "with a positive index" do
          context "and a positive length" do
            it "replaces the elements found starting at the index for the length with the value" do
              sa = StupidArray.new([1, 2, 3, 4])
              sa[0, 2] = 4
              expect(sa).to eq [4, 3, 4]
            end
            it "adds the array" do
              sa = StupidArray.new([1, 2, 3, 4])
              sa[0, 2] = %w[a b]
              expect(sa).to eq ["a", "b", 3, 4]
            end
            it "removes elements if length is past the end of the value array" do
              sa = StupidArray.new([1, 2, 3, 4])
              sa[0, 4] = %w[a b]
              expect(sa).to eq %w[a b]
            end
            it "keeps the beginning of the array if index is greater than 0" do
              sa = StupidArray.new([1, 2, 3, 4, 5])
              sa[1, 2] = %w[a b]
              expect(sa).to eq [1, "a", "b", 4, 5]
            end
            it "inserts the full value of an array, even if the array is greater than the length" do
              sa = StupidArray.new([1, 2, 3, 4, 5])
              sa[1, 1] = %w[a b]
              expect(sa).to eq [1, "a", "b", 3, 4, 5]
            end
            it "returns the value" do
              sa = StupidArray.new([1, 2, 3, 4])
              expect(sa[1, 1] = %w[a b]).to eq %w[a b]
            end
          end
          context "and a negative length" do
            it "raises an StupidArray::IndexOutOfRangeError" do
              sa = StupidArray.new([1, 2, 3])
              expect { sa[0, -5] = 10 }.to raise_error StupidArray::IndexOutOfRangeError
            end
          end
        end
        context "with a negative index" do
          context "and a positive length" do
            it "replaces elements in the StupidArray staring at the index to the length of the value" do
              sa = StupidArray.new([1, 2, 3, 4, 5, 6])
              sa[-4, 1] = %w[a b]
              expect(sa).to eq [1, 2, "a", "b", 4, 5, 6]
            end
            it "removes the original StupidArray when the length goes beyond the end" do
              sa = StupidArray.new([1, 2, 3, 4, 5, 6])
              sa[-4, 10] = %w[a b]
              expect(sa).to eq [1, 2, "a", "b"]
            end
          end
          context "and a negative length" do
            it "raises a StupidArray::IndexOutOfRangeError" do
              sa = StupidArray.new([1, 2, 3, 4])
              expect { sa[-1, -1] = %w[a b] }.to raise_error StupidArray::IndexOutOfRangeError
            end
          end
        end
      end
    end
    context "#reverse" do
      it "reverses the elements in the StupidArray" do
        sa = StupidArray.new([1, 2, 3])
        expect(sa.reverse).to eq [3, 2, 1]
      end

      it "does not modify the StupidArray" do
        sa = StupidArray.new([1, 2, 3])
        sa.reverse
        expect(sa).to eq [1, 2, 3]
      end
    end

    context "#reverse!" do
      it "reverses the elements in the StupidArray" do
        sa = StupidArray.new([1, 2, 3])
        expect(sa.reverse!).to eq [3, 2, 1]
      end

      it "modifies the StupidArray" do
        sa = StupidArray.new([1, 2, 3])
        sa.reverse!
        expect(sa).to eq [3, 2, 1]
      end
    end
  end

  context "displaying a StupidArray" do
    context "#join" do
      it "joins the elements in the StupidArray" do
        sa = StupidArray.new([1, 2, 3])
        expect(sa.join).to eq "123"
      end

      it "joins the elements in the StupidArray with a seperator" do
        sa = StupidArray.new([1, 2, 3])
        expect(sa.join(",")).to eq "1,2,3"
      end

      it "recursively joins elements" do
        inner_sa = StupidArray.new(%i[x y])
        middle_sa = StupidArray.new([1, 2, inner_sa])
        outer_sa = StupidArray.new(["a", middle_sa, "b"])
        expect(outer_sa.join("-")).to eq "a-1-2-x-y-b"
      end

      it "returns an empty string when length is 0" do
        sa = StupidArray.new
        expect(sa.join(",")).to eq ""
      end

      it "returns the first element as a string if the length is 1" do
        sa = StupidArray.new([1])
        expect(sa.join(",")).to eq "1"
      end
    end
    context "#to_s" do
      it "joins the StupidArray with a ', ', with brackets" do
        sa = StupidArray.new([1, 2, 3])
        expect(sa.to_s).to eq "[1, 2, 3]"
      end

      it "handles nested StupidArrays" do
        inner1 = StupidArray.new([1])
        inner2 = StupidArray.new([2])
        sa = StupidArray.new([inner1, inner2])
        expect(sa.to_s).to eq "[[1], [2]]"
      end

      it "returns nils as the string 'nil'" do
        sa = StupidArray.new(3)
        expect(sa.to_s).to eq "[nil, nil, nil]"
      end
    end
  end
end
