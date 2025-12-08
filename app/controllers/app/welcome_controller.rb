# frozen_string_literal: true

class App::WelcomeController < AppController
  def index
    @test_account = Current.archive.accounts.includes(:file_system).find_by!(type: "Account::Capital::Checking", name: "Meat funds")
  end
end
