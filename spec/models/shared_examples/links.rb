RSpec.shared_examples "links" do
  it { should have_many(:links).dependent(:destroy) }
end
