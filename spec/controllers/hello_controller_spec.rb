require 'rails_helper'

RSpec.describe HelloController, type: :controller do
  let(:result) { 1 }
  context "test" do
    it "hoge" do
      expect(result).to eq 1
    end
  end

end
