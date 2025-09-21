# frozen_string_literal: true

class App::ArchiveSchema < ApplicationSchema
  attribute :id, :integer
  attribute :name, :string
  attribute :description, :string
end
