RSpec.shared_examples "votes" do
  it { should have_many(:votes).dependent(:destroy) }
  it { should accept_nested_attributes_for :votes }
end
