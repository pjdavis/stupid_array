# frozen_string_literal: true

RSpec.describe StupidArray::Querying do
  describe "#all?" do
    context "with no arguments" do
      context "with an empty StupidArray" do
        it "returns true" do
          sa = StupidArray.new
          expect(sa.all?).to be true
        end
      end
      context "with a truthy StupidArray" do
        it "returns true" do
          sa = StupidArray.new([1, "yes", :foo])
          expect(sa.all?).to be true
        end
      end
      context "with a falsey StupidArray" do
        it "returns false" do
          sa = StupidArray.new([0, nil, 2])
          expect(sa.all?).to be false
        end
      end
    end
    context "with an object" do
      context "with an empty StupidArray" do
        context "with a regex" do
          it "returns true" do
            sa = StupidArray.new
            expect(sa.all?(/foo/)).to be true
          end
        end
        context "with an object" do
          it "returns true" do
            sa = StupidArray.new
            expect(sa.all?(0)).to be true
          end
        end
      end
      context "with all equivalent objects" do
        context "with a regex" do
          it "returns true" do
            sa = StupidArray.new(%w[food fool foot])
            expect(sa.all?(/foo/)).to be true
          end
        end
        context "with an object" do
          it "returns true" do
            sa = StupidArray.new([0, 0, 0])
            expect(sa.all?(0)).to be true
          end
        end
      end
      context "with non-equivalent objects" do
        context "with a regex" do
          it "returns false" do
            sa = StupidArray.new(%w[food drink])
            expect(sa.all?(/foo/)).to be false
          end
        end
        context "with an object" do
          it "returns false" do
            sa = StupidArray.new([0, 1, 2])
            expect(sa.all?(0)).to be false
          end
        end
      end
    end
    context "with a block" do
      context "with an argument" do
        it "raises a warning" do
          std_err = $stderr
          $stderr = StringIO.new
          sa = StupidArray.new([1, 2, 3])
          sa.all?(3) { |element| element < 3 }
          $stderr.rewind
          expect($stderr.string.chomp).to eq "warning: given block not used"
          $stderr = std_err
        end
        it "uses the argument" do
          sa = StupidArray.new([1, 2, 3])
          expect(sa.all?(3) { |element| element < 4 }).to be false
        end
      end
      context "without an argument" do
        context "that returns true for all values" do
          it "returns true" do
            sa = StupidArray.new([0, 1, 2])
            expect(sa.all? { |element| element < 3 }).to be true
          end
        end
        context "that returns false for at least one value" do
          it "returns false" do
            sa = StupidArray.new([1, 2, 3])
            expect(sa.all? { |element| element < 2 }).to be false
          end
        end
      end
    end
  end
  describe "#any?" do
    context "with no arguments" do
      context "with an empty StupidArray" do
        it "returns true" do
          sa = StupidArray.new
          expect(sa.any?).to be false
        end
      end
      context "with a truthy StupidArray" do
        it "returns true" do
          sa = StupidArray.new([nil, false, 0])
          expect(sa.any?).to be true
        end
      end
      context "with a falsey StupidArray" do
        it "returns false" do
          sa = StupidArray.new([nil, false])
          expect(sa.any?).to be false
        end
      end
    end
    context "with an object" do
      context "with an empty StupidArray" do
        context "with a regex" do
          it "returns true" do
            sa = StupidArray.new
            expect(sa.any?(/foo/)).to be false
          end
        end
        context "with an object" do
          it "returns true" do
            sa = StupidArray.new
            expect(sa.any?(0)).to be false
          end
        end
      end
      context "with any equivalent objects" do
        context "with a regex" do
          it "returns true" do
            sa = StupidArray.new(%w[food drink])
            expect(sa.any?(/foo/)).to be true
          end
        end
        context "with an object" do
          it "returns true" do
            sa = StupidArray.new([0, 1, 2])
            expect(sa.any?(1)).to be true
          end
        end
      end
      context "with non-equivalent objects" do
        context "with a regex" do
          it "returns false" do
            sa = StupidArray.new(%w[food drink])
            expect(sa.any?(/bar/)).to be false
          end
        end
        context "with an object" do
          it "returns false" do
            sa = StupidArray.new([0, 1, 2])
            expect(sa.any?(3)).to be false
          end
        end
      end
    end
    context "with a block" do
      context "with an argument" do
        it "raises a warning" do
          std_err = $stderr
          $stderr = StringIO.new
          sa = StupidArray.new([1, 2, 3])
          sa.any?(3) { |element| element < 3 }
          $stderr.rewind
          expect($stderr.string.chomp).to eq "warning: given block not used"
          $stderr = std_err
        end
        it "uses the argument" do
          sa = StupidArray.new([1, 2, 3])
          expect(sa.any?(3) { |element| element > 4 }).to be true
        end
      end
      context "without an argument" do
        context "that returns true for any values" do
          it "returns true" do
            sa = StupidArray.new([0, 1, 2])
            expect(sa.any? { |element| element > 1 }).to be true
          end
        end
        context "that returns false for at least one value" do
          it "returns false" do
            sa = StupidArray.new([0, 1, 2])
            expect(sa.any? { |element| element > 2 }).to be false
          end
        end
      end
    end
  end
  describe "#count" do
    context "with no arguments" do
      context "with an empty StupidArray" do
        it "retuns 0" do
          sa = StupidArray.new
          expect(sa.count).to eq 0
        end
      end
      context "with a StupidArray with elements" do
        it "returns the number of elements" do
          sa = StupidArray.new([1, 2, 3])
          expect(sa.count).to eq 3
        end
      end
    end
    context "with an argument" do
      context "without a block" do
        context "with no matching elements" do
          it "returns 0" do
            sa = StupidArray.new([1, 2, 3])
            expect(sa.count(0)).to be 0
          end
        end
        context "with matching elements" do
          it "returns the number of matching elements" do
            sa = StupidArray.new([0, 1, 2, 0.0])
            expect(sa.count(0)).to eq 2
          end
        end
      end
      context "with a block" do
        it "raises a warning" do
          std_err = $stderr
          $stderr = StringIO.new
          sa = StupidArray.new([1, 2, 3])
          sa.count(3) { |element| element < 3 }
          $stderr.rewind
          expect($stderr.string.chomp).to eq "warning: given block not used"
          $stderr = std_err
        end
        it "uses the argument" do
          sa = StupidArray.new([1, 2, 3])
          expect(sa.count(3) { |element| element > 4 }).to eq 1
        end
      end
    end
    context "with a block" do
      context "with no matching elements" do
        it "returns 0" do
          sa = StupidArray.new([1, 2, 3])
          expect(sa.count { |element| element > 3 }).to be 0
        end
      end
      context "with matching elements" do
        it "returns the number of matching elements" do
          sa = StupidArray.new([0, 1, 2, 3])
          expect(sa.count { |element| element > 1 }).to eq 2
        end
      end
    end
  end
  describe "#empty?" do
    it "returns true if StupidArray is empty" do
      sa = StupidArray.new
      expect(sa.empty?).to be true
    end
    it "returns false if StupidArray is not empty" do
      sa = StupidArray.new(1)
      expect(sa.empty?).to be false
    end
  end
  describe "#hash" do
    context "with the same elements" do
      context "in the same order" do
        it "does match" do
          sa1 = StupidArray.new([1, 2, 3])
          sa2 = StupidArray.new([1, 2, 3])
          expect(sa1.hash).to eq sa2.hash
        end
      end
      context "in a different order" do
        it "does not match" do
          sa1 = StupidArray.new([1, 2, 3])
          sa2 = StupidArray.new([1, 3, 2])
          expect(sa1.hash).not_to eq sa2.hash
        end
      end
    end
    context "with different elements" do
      it "does not match" do
        sa1 = StupidArray.new([1, 2, 3])
        sa2 = StupidArray.new([3, 4, 5])
        expect(sa1.hash).not_to eq sa2.hash
      end
    end
  end
  describe "#include?" do
    context "with an included element" do
      it "returns true" do
        sa = StupidArray.new([1, 2, 3])
        expect(sa.include?(2)).to be true
      end
    end
    context "without an included element" do
      it "returns false" do
        sa = StupidArray.new([1, 2, 3])
        expect(sa.include?(6)).to be false
      end
    end
  end
  describe "#index" do
    context "with no arguments" do
      it "returns an enumerator" do
        sa = StupidArray.new([1, 2, 3])
        expect(sa.index).to be_an(Enumerator)
      end
      it "has the elements in the enumerator" do
        sa = StupidArray.new([1, 2, 3])
        sa.index.each_with_index do |element, index|
          expect(sa[index]).to eq element
        end
      end
    end
    context "with one argument" do
      context "and no block" do
        context "with a matching element" do
          it "returns the index of the element" do
            sa = StupidArray.new([:foo, "bar", 2])
            expect(sa.index("bar")).to eq 1
          end
        end
        context "with multiple matching elements" do
          it "returns the index of the first element" do
            sa = StupidArray.new([:foo, "bar", 2, "bar"])
            expect(sa.index("bar")).to eq 1
          end
        end
        context "with no matching elements" do
          it "returns nil" do
            sa = StupidArray.new([:foo, 2])
            expect(sa.index("bar")).to be nil
          end
        end
      end
      context "and a block" do
        it "raises a warning" do
          std_err = $stderr
          $stderr = StringIO.new
          sa = StupidArray.new([1, 2, 3])
          sa.index(1) { |element| element < 3 }
          $stderr.rewind
          expect($stderr.string.chomp).to eq "warning: given block not used"
          $stderr = std_err
        end
        it "uses the argument" do
          sa = StupidArray.new([1, 2, 3])
          expect(sa.index(1) { |element| element > 4 }).to eq 0
        end
      end
    end
    context "with a block" do
      context "with a matching element" do
        it "returns the index of the element" do
          sa = StupidArray.new([:foo, "bar", 2])
          expect(sa.index { |element| element == "bar" }).to eq 1
        end
      end
      context "with multiple matching elements" do
        it "returns the index of the first element" do
          sa = StupidArray.new([:foo, "bar", 2, "bar"])
          expect(sa.index { |element| element == "bar" }).to eq 1
        end
      end
      context "with no matching elements" do
        it "returns nil" do
          sa = StupidArray.new([:foo, 2])
          expect(sa.index { |element| element == "bar" }).to be nil
        end
      end
    end
  end
  describe "#length" do
    it "returns the size of the StupidArray" do
      sa = StupidArray.new(3)
      expect(sa.length).to eq 3
    end

    it "has size aliased to length" do
      sa = StupidArray.new(3)
      expect(sa.size).to eq 3
    end
  end
  describe "#none?" do
    context "with no arguments" do
      context "with an empty StupidArray" do
        it "returns true" do
          sa = StupidArray.new
          expect(sa.none?).to be true
        end
      end
      context "with a truthy StupidArray" do
        it "returns false" do
          sa = StupidArray.new([nil, 0, false])
          expect(sa.none?).to be false
        end
      end
      context "with a falsey StupidArray" do
        it "returns false" do
          sa = StupidArray.new([nil, false])
          expect(sa.none?).to be true
        end
      end
    end
    context "with an object" do
      context "with an empty StupidArray" do
        context "with a regex" do
          it "returns true" do
            sa = StupidArray.new
            expect(sa.none?(/foo/)).to be true
          end
        end
        context "with an object" do
          it "returns true" do
            sa = StupidArray.new
            expect(sa.none?(0)).to be true
          end
        end
      end
      context "with no equivalent objects" do
        context "with a regex" do
          it "returns true" do
            sa = StupidArray.new(%w[food drink])
            expect(sa.none?(/bar/)).to be true
          end
        end
        context "with an object" do
          it "returns true" do
            sa = StupidArray.new([0, 1, 2])
            expect(sa.none?(3)).to be true
          end
        end
      end
      context "with equivalent objects" do
        context "with a regex" do
          it "returns false" do
            sa = StupidArray.new(%w[food drink])
            expect(sa.none?(/foo/)).to be false
          end
        end
        context "with an object" do
          it "returns false" do
            sa = StupidArray.new([0, 1, 2])
            expect(sa.none?(1)).to be false
          end
        end
      end
    end
    context "with a block" do
      context "with an argument" do
        it "raises a warning" do
          std_err = $stderr
          $stderr = StringIO.new
          sa = StupidArray.new([1, 2, 3])
          sa.none?(3) { |element| element < 3 }
          $stderr.rewind
          expect($stderr.string.chomp).to eq "warning: given block not used"
          $stderr = std_err
        end
        it "uses the argument" do
          sa = StupidArray.new([1, 2, 3])
          expect(sa.none?(3) { |element| element > 4 }).to be false
        end
      end
      context "without an argument" do
        context "that returns true for none values" do
          it "returns true" do
            sa = StupidArray.new([0, 1, 2])
            expect(sa.none? { |element| element > 3 }).to be true
          end
        end
        context "that returns false for at least one value" do
          it "returns false" do
            sa = StupidArray.new([1, 2, 3])
            expect(sa.none? { |element| element > 1 }).to be false
          end
        end
      end
    end
  end
  describe "#one?" do
    context "with no arguments" do
      context "with an empty StupidArray" do
        it "returns false" do
          sa = StupidArray.new
          expect(sa.one?).to be false
        end
      end
      context "with a single truthy StupidArray" do
        it "returns true" do
          sa = StupidArray.new([nil, 0, false])
          expect(sa.one?).to be true
        end
      end
      context "with multiple truthy elements" do
        it "returns false" do
          sa = StupidArray.new([0, 0])
          expect(sa.one?).to be false
        end
      end
      context "with a falsey StupidArray" do
        it "returns false" do
          sa = StupidArray.new([nil, nil])
          expect(sa.one?).to be false
        end
      end
    end
    context "with an object" do
      context "with an empty StupidArray" do
        context "with a regex" do
          it "returns false" do
            sa = StupidArray.new
            expect(sa.one?(/foo/)).to be false
          end
        end
        context "with an object" do
          it "returns false" do
            sa = StupidArray.new
            expect(sa.one?(0)).to be false
          end
        end
      end
      context "with no equivalent objects" do
        context "with a regex" do
          it "returns false" do
            sa = StupidArray.new(%w[food drink])
            expect(sa.one?(/bar/)).to be false
          end
        end
        context "with an object" do
          it "returns false" do
            sa = StupidArray.new([0, 1, 2])
            expect(sa.one?(3)).to be false
          end
        end
      end
      context "with one equivalent objects" do
        context "with a regex" do
          it "returns true" do
            sa = StupidArray.new(%w[food drink])
            expect(sa.one?(/foo/)).to be true
          end
        end
        context "with an object" do
          it "returns true" do
            sa = StupidArray.new([0, 1, 2])
            expect(sa.one?(1)).to be true
          end
        end
      end
      context "with multiple equivalent objects" do
        context "with a regex" do
          it "returns false" do
            sa = StupidArray.new(%w[foot food drink])
            expect(sa.one?(/foo/)).to be false
          end
        end
        context "with an object" do
          it "returns false" do
            sa = StupidArray.new([0, 0, 1])
            expect(sa.one?(0)).to be false
          end
        end
      end
    end
    context "with a block" do
      context "with an argument" do
        it "raises a warning" do
          std_err = $stderr
          $stderr = StringIO.new
          sa = StupidArray.new([1, 2, 3])
          sa.one?(3) { |element| element < 3 }
          $stderr.rewind
          expect($stderr.string.chomp).to eq "warning: given block not used"
          $stderr = std_err
        end
        it "uses the argument" do
          sa = StupidArray.new([1, 2, 3])
          expect(sa.one?(3) { |element| element > 4 }).to be true
        end
      end
      context "without an argument" do
        context "that returns true for one values" do
          it "returns true" do
            sa = StupidArray.new([0, 1, 2])
            expect(sa.one? { |element| element > 1 }).to be true
          end
        end
        context "that returns true for multiple values" do
          it "returns false" do
            sa = StupidArray.new([1, 2, 3])
            expect(sa.one? { |element| element > 1 }).to be false
          end
        end
        context "that returns false for all values" do
          it "returns false" do
            sa = StupidArray.new([1, 1, 2])
            expect(sa.one? { |element| element > 2 }).to be false
          end
        end
      end
    end
  end
  describe "#rindex" do
    context "with no arguments" do
      it "returns an enumerator" do
        sa = StupidArray.new([1, 2, 3])
        expect(sa.rindex).to be_an(Enumerator)
      end
      it "has the elements in the enumerator" do
        sa = StupidArray.new([1, 2, 3])
        sa.rindex.each_with_index do |element, rindex|
          expect(sa[rindex]).to eq element
        end
      end
    end
    context "with one argument" do
      context "and no block" do
        context "with a matching element" do
          it "returns the index of the element" do
            sa = StupidArray.new([:foo, "bar", 2])
            expect(sa.rindex("bar")).to eq 1
          end
        end
        context "with multiple matching elements" do
          it "returns the index of the last element" do
            sa = StupidArray.new([:foo, "bar", 2, "bar"])
            expect(sa.rindex("bar")).to eq 3
          end
        end
        context "with no matching elements" do
          it "returns nil" do
            sa = StupidArray.new([:foo, 2])
            expect(sa.rindex("bar")).to be nil
          end
        end
      end
      context "and a block" do
        it "raises a warning" do
          std_err = $stderr
          $stderr = StringIO.new
          sa = StupidArray.new([1, 2, 3])
          sa.rindex(1) { |element| element < 3 }
          $stderr.rewind
          expect($stderr.string.chomp).to eq "warning: given block not used"
          $stderr = std_err
        end
        it "uses the argument" do
          sa = StupidArray.new([1, 2, 3, 1])
          expect(sa.rindex(1) { |element| element > 4 }).to eq 3
        end
      end
    end
    context "with a block" do
      context "with a matching element" do
        it "returns the index of the element" do
          sa = StupidArray.new([:foo, "bar", 2])
          expect(sa.rindex { |element| element == "bar" }).to eq 1
        end
      end
      context "with multiple matching elements" do
        it "returns the index of the last element" do
          sa = StupidArray.new([:foo, "bar", 2, "bar"])
          expect(sa.rindex { |element| element == "bar" }).to eq 3
        end
      end
      context "with no matching elements" do
        it "returns nil" do
          sa = StupidArray.new([:foo, 2])
          expect(sa.rindex { |element| element == "bar" }).to be nil
        end
      end
    end
  end
end
