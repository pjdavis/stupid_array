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
end
