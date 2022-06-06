# frozen_string_literal: true

RSpec.describe StupidArray::Fetching do
  describe "#[]" do
    context "with [index]" do
      context "in range" do
        context "with a positive integer" do
          it "returns the element at offset index" do
            sa = StupidArray.new([:foo, "bar", 2])
            expect(sa[0]).to eql :foo
          end
        end
        context "with a negative integer" do
          it "returns relative to end of self" do
            sa = StupidArray.new([:foo, "bar", 2])
            expect(sa[-1]).to eq 2
          end
        end
      end
      context "out of range" do
        it "returns nil" do
          sa = StupidArray.new([:foo, "bar", 2])
          expect(sa[10]).to be nil
        end
      end
      context "not an integer" do
        context "can be coerced into an integer" do
          it "returns what the coerced object becomes" do
            sa = StupidArray.new([:foo, "bar", 2])
            expect(sa[0.5]).to eq :foo
          end
        end
        context "can not be corrced into an integer" do
          it "raises 'no implicit conversion to Integer' (TypeError)" do
            sa = StupidArray.new([:foo, "bar", 2])
            expect { sa["a"] }.to raise_error TypeError
          end
        end
      end
    end
    context "with [start, length]" do
      context "with 2 positive integers" do
        context "the first argument is in range" do
          context "the second argument is within the length of the StupidArray" do
            it "returns a new StupidArray starting at start wtih length elements" do
              sa = StupidArray.new([:foo, "bar", 2])
              expect(sa[0, 2]).to eq StupidArray.new([:foo, "bar"])
            end
          end
          context "the second argument is outside the length of the StupidArray" do
            it "returns all elements from start to end" do
              sa = StupidArray.new([:foo, "bar", 2])
              expect(sa[1, 5]).to eq StupidArray.new(["bar", 2])
            end
          end
        end
        context "the first argument is out of range" do
          it "returns nil" do
            sa = StupidArray.new([:foo, "bar", 2])
            expect(sa[5, 1]).to be nil
          end
        end
        context "start is the same as #size" do
          context "length is >= 0" do
            it "returns a new empty StupidArray" do
              sa = StupidArray.new([:foo, "bar", 2])
              expect(sa[3, 1]).to eq StupidArray.new
            end
          end
        end
      end
      context "with a negative and positive integer" do
        context "start is in range of the StupidArray" do
          context "length is in range of the StupidArray" do
            it "returns a new StupidArray from the negative offset with length elements" do
              sa = StupidArray.new([:foo, "bar", 2])
              expect(sa[-2, 2]).to eq StupidArray.new(["bar", 2])
            end
          end
          context "length is out of range of the StupidArray" do
            it "returns elements to the end of the StupidArray" do
              sa = StupidArray.new([:foo, "bar", 2])
              expect(sa[-2, 10]).to eq StupidArray.new(["bar", 2])
            end
          end
        end
        context "start is out of range of the StupidArray" do
          it "returns nil" do
            sa = StupidArray.new([:foo, "bar", 2])
            expect(sa[-4, 2]).to be nil
          end
        end
      end
      context "with a positive and negative integer" do
        it "returns nil" do
          sa = StupidArray.new([:foo, "bar", 2])
          expect(sa[1, -1]).to be nil
        end
      end
      context "with 2 negative integers" do
        it "returns nil" do
          sa = StupidArray.new([:foo, "bar", 2])
          expect(sa[-1, -1]).to be nil
        end
      end
    end
    context "with [range]" do
      context "with positive start" do
        context "that is less than StupidArray size" do
          context "with positive end" do
            it "returns elements using #min as start and #size as length" do
              sa = StupidArray.new([:foo, "bar", 2])
              expect(sa[1..2]).to eq StupidArray.new(["bar", 2])
            end
          end
          context "with negative end" do
            it "returns elements using #min as the start and using #end as the negative index" do
              sa = StupidArray.new([:foo, "bar", 2])
              expect(sa[0..-2]).to eq StupidArray.new([:foo, "bar"])
            end
          end
        end
        context "that is equal to StupidArray size" do
          it "returns a new empty StupidArray" do
            sa = StupidArray.new([:foo, "bar", 2])
            expect(sa[3..4]).to eq StupidArray.new
          end
        end
        context "that is greater than StupidArray size" do
          it "returns nil" do
            sa = StupidArray.new([:foo, "bar", 2])
            expect(sa[10..11]).to be nil
          end
        end
      end
      context "with negative start" do
        it "caluclates the start index from the end" do
          sa = StupidArray.new([:foo, "bar", 2])
          expect(sa[-2..2]).to eq StupidArray.new(["bar", 2])
        end
      end
    end
    context "with [aseq]" do
      context "that is in range" do
        it "returns a new StupidArray of elements corresponding to the indexs of the sequence" do
          sa = StupidArray.new(["--", "data1", "--", "data2", "--", "data3"])
          expect(sa[(1..).step(2)]).to eq StupidArray.new(%w[data1 data2 data3])
        end
      end
      context "that is out of range" do
        it "throws RangeError" do
          sa = StupidArray.new(["--", "data1", "--", "data2", "--", "data3"])
          expect { sa[(1..11).step(2)] }.to raise_error(RangeError)
        end
      end
    end
  end
end
