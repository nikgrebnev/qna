class ReputationJob < ApplicationJob
  queue_as :default

  def perform(object)
    ServiceReputation.calculate(object)
  end
end
