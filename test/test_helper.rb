ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    include ActiveSupport::Testing::TimeHelpers

    # Run tests in parallel with specified workers
    parallelize_setup do
      # Freezing time globally make tests deterministic while February can be taken into consideration without specific
      # setup. Additionally, according to Google Gemini, as of November 10th, 2025, doing this makes so any usages of
      # travel or travel_to inside any test case will use this global time as the starting point of such time mocks.
      # Which is really useful, in my opinion. Then we can test our code based on a snapshot of the application "state"
      # as of a specific moment in time, making so any test case represent any possible behavior the application
      # has in such an instant.

      travel_to Time.zone.local(Time.current.year, 3, 19, 21, 15, 40)
    end

    parallelize_teardown do
      # We need to ensure that we revert the global time mock to prevent leaks
      travel_back
    end

    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
