# frozen_string_literal: true

RSpec.describe StupidArray do
  context "equality" do
    it "is equal to an array with the same elements" do
      a = [1, 2, 3]
      sa = StupidArray.new(a)
      expect(sa).to eq a
    end

    it "is not equal to an array with different elements" do
      a = [1, 2, 3]
      sa = StupidArray.new(a.take(2))
      expect(sa).not_to eq a
    end
  end
end
