RSpec.shared_examples "comments" do
  it { should have_many(:comments).dependent(:destroy) }
  it { should accept_nested_attributes_for :comments }
end
