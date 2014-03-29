require "test_helper"

describe KeyControl do

  describe ".available?" do
    it "returns false if the keyctl library can not be found" do
      KeyControl.stub(:library_names, %w[badlib]) do
        KeyControl.available?.must_equal false
      end
    end

    it "returns true if the keyctl library is available" do
      KeyControl.available?.must_equal true
    end
  end
end
