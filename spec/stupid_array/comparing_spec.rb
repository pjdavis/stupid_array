# frozen_string_literal: true

RSpec.describe StupidArray::Comparing do
  describe "#<=>" do
    context "when self is the same size as other" do
      context "when any comparison is -1" do
        it "returns -1" do
          sa1 = StupidArray.new([0, 1, 2])
          sa2 = StupidArray.new([0, 1, 3])
          expect(sa1 <=> sa2).to eq(-1)
        end
      end
      context "when any comparison is 1" do
        it "returns 1" do
          sa1 = StupidArray.new([0, 1, 2])
          sa2 = StupidArray.new([0, 1, 1])
          expect(sa1 <=> sa2).to eq 1
        end
      end
      context "when all comparisons are 0" do
        it "returns 0" do
          sa1 = StupidArray.new([0, 1, 2])
          sa2 = StupidArray.new([0, 1, 2])
          expect(sa1 <=> sa2).to eq 0
        end
      end
    end
    context "when self is smaller than other" do
      it "returns -1" do
        sa1 = StupidArray.new([0, 1, 2])
        sa2 = StupidArray.new([0, 1, 2, 3])
        expect(sa1 <=> sa2).to eq(-1)
      end
    end
    context "when self is larger than other" do
      it "returns 1" do
        sa1 = StupidArray.new([0, 1, 2])
        sa2 = StupidArray.new([0, 1])
        expect(sa1 <=> sa2).to eq 1
      end
    end
  end
  describe "#==" do
    context "when other is a StupidArray" do
      context "when size is different" do
        context "when size is bigger" do
          it "returns false" do
            sa1 = StupidArray.new([0, 1, 2])
            sa2 = StupidArray.new([0, 1])
            expect(sa1 == sa2).to be false
          end
          context "when size is smaller" do
            it "returns false" do
              sa1 = StupidArray.new([0, 1])
              sa2 = StupidArray.new([0, 1, 2])
              expect(sa1 == sa2).to be false
            end
          end
        end
        context "when size is the same" do
          context "when all elements return == true" do
            it "returns true" do
              sa1 = StupidArray.new([0, 1, 2])
              sa2 = StupidArray.new([0, 1, 2])
              expect(sa1 == sa2).to be true
            end
          end
          context "when some elements return == false" do
            it "returns false" do
              sa1 = StupidArray.new([0, 1, 2])
              sa2 = StupidArray.new([1, 3, 5])
              expect(sa1 == sa2).to be false
            end
          end
          context "when the same elements exist, but in a different order" do
            it "returns false" do
              sa1 = StupidArray.new([0, 1, 2])
              sa2 = StupidArray.new([2, 1, 0])
              expect(sa1 == sa2).to be false
            end
          end
        end
      end
    end
    context "when other is an Array" do
      context "when size is different" do
        context "when size is bigger" do
          it "returns false" do
            sa = StupidArray.new([0, 1, 2])
            a = [0, 1]
            expect(sa == a).to be false
          end
          context "when size is smaller" do
            it "returns false" do
              sa = StupidArray.new([0, 1])
              a = [0, 1, 2]
              expect(sa == a).to be false
            end
          end
        end
        context "when size is the same" do
          context "when all elements return == true" do
            it "returns true" do
              sa = StupidArray.new([0, 1, 2])
              a = [0, 1, 2]
              expect(sa == a).to be true
            end
          end
          context "when some elements return == false" do
            it "returns false" do
              sa = StupidArray.new([0, 1, 2])
              a = [1, 3, 5]
              expect(sa == a).to be false
            end
          end
          context "when the same elements exist, but in a different order" do
            it "returns false" do
              sa = StupidArray.new([0, 1, 2])
              a = [2, 1, 0]
              expect(sa == a).to be false
            end
          end
        end
      end
    end
    context "when other is not an array or StupidArray" do
      it "returns false" do
        sa = StupidArray.new([1, 2, 3])
        other = "String"
        expect(sa == other).to be false
      end
    end
  end
  describe "#eql?" do
    context "when other is a StupidArray" do
      context "when size is different" do
        context "when size is bigger" do
          it "returns false" do
            sa1 = StupidArray.new([0, 1, 2])
            sa2 = StupidArray.new([0, 1])
            expect(sa1.eql?(sa2)).to be false
          end
          context "when size is smaller" do
            it "returns false" do
              sa1 = StupidArray.new([0, 1])
              sa2 = StupidArray.new([0, 1, 2])
              expect(sa1.eql?(sa2)).to be false
            end
          end
        end
        context "when size is the same" do
          context "when all elements return.eql? true" do
            it "returns true" do
              sa1 = StupidArray.new([0, 1, 2])
              sa2 = StupidArray.new([0, 1, 2])
              expect(sa1.eql?(sa2)).to be true
            end
          end
          context "when some elements return.eql? false" do
            it "returns false" do
              sa1 = StupidArray.new([0, 1, 2])
              sa2 = StupidArray.new([1, 3, 5])
              expect(sa1.eql?(sa2)).to be false
            end
          end
          context "when the same elements exist, but in a different order" do
            it "returns false" do
              sa1 = StupidArray.new([0, 1, 2])
              sa2 = StupidArray.new([2, 1, 0])
              expect(sa1.eql?(sa2)).to be false
            end
          end
        end
      end
    end
    context "when other is an Array" do
      context "when size is different" do
        context "when size is bigger" do
          it "returns false" do
            sa = StupidArray.new([0, 1, 2])
            a = [0, 1]
            expect(sa.eql?(a)).to be false
          end
          context "when size is smaller" do
            it "returns false" do
              sa = StupidArray.new([0, 1])
              a = [0, 1, 2]
              expect(sa.eql?(a)).to be false
            end
          end
        end
        context "when size is the same" do
          context "when all elements return.eql? true" do
            it "returns true" do
              sa = StupidArray.new([0, 1, 2])
              a = [0, 1, 2]
              expect(sa.eql?(a)).to be true
            end
          end
          context "when some elements return.eql? false" do
            it "returns false" do
              sa = StupidArray.new([0, 1, 2])
              a = [1, 3, 5]
              expect(sa.eql?(a)).to be false
            end
          end
          context "when the same elements exist, but in a different order" do
            it "returns false" do
              sa = StupidArray.new([0, 1, 2])
              a = [2, 1, 0]
              expect(sa.eql?(a)).to be false
            end
          end
        end
      end
    end
    context "when other is not an Array or StupidArray" do
      it "returns false" do
        sa = StupidArray.new([1, 2, 3])
        other = "String"
        expect(sa.eql?(other)).to be false
      end
    end
  end
end
