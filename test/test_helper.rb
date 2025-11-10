ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

# Freezing time globally make tests deterministic while February can be taken into consideration without specific setup.
# Additionally, according to Google Gemini as of November 10th, 2025, doing this makes so any usages of travel or
# travel_to inside any test case will use this global time as the starting point of such time mocks. Which is really
# usefully in my opinion because then we can test our code based on a snapshot of the application "state" as of a
# specific moment in time, making so any test case represent any possible behavior the application have in such instant.
SPECIFIC_FROZEN_TIME = Time.zone.local(Time.current.year, 3, 19, 21, 15, 40)

ActiveSupport::Testing::TimeHelpers.travel_to SPECIFIC_FROZEN_TIME

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

# We need to ensure that we revert the global time mock to prevent leaks
Minitest.after_run do
  ActiveSupport::Testing::TimeHelpers.travel_back
end
