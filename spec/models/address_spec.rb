require 'spec_helper'

describe Address do
  describe "#initialize" do
    it "works with no args" do
      a = Address.new
      a.should be_a(Address)
    end
    it "works with a valid hash" do
      a = Address.new({"line1" => "631 San Bruno Ave"})
      a.should be_a(Address)
    end
    it "throws an error with a non-hash" do
      expect {
        a = Address.new("This is not a hash")
      }.to raise_error
    end
    it "ignores invalid keys" do
      a = Address.new({"foobar" => "garply"})
      a.to_h.should be_empty
    end
    it "sets the getters based on the hash" do
      ["line1", "line2", "line3", "city", "state", "zip"].each do |attrib|
        a = Address.new({attrib => "foobar"})
        a.send(attrib).should eq "foobar"
      end
    end
  end
  describe "#to_h" do
    it "returns a hash with the keys in the right order" do
      a = Address.new
      a.city = "Denver"
      a.zip = "80014"
      a.line1 = "11951 E Yale Ct"
      a.to_h.should eq({ "line1" => "11951 E Yale Ct",
                         "city" => "Denver",
                         "zip" => "80014"})
    end
  end
end
