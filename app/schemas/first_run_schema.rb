# frozen_string_literal: true

# FirstRunForm is the data representation and schema validator for the first run process.
class FirstRunSchema < ApplicationSchema
  has_secure_password

  attribute :username, :string
  attribute :email_address, :string
  attribute :password_digest, :string

  validates :username, presence: true, length: { maximum: 256 }
  validates :email_address, presence: true, email: true

  validate :email_address_uniqueness_validation
  validate :username_uniqueness_validation

  define_model_callbacks :validation

  normalizes :email_address, with: ->(email) { email.strip.downcase }
  normalizes :tag, with: ->(tag) { tag.strip.gsub(/\s+/, "") }

  private
    def email_address_uniqueness_validation
      errors.add(:email_address, :uniqueness) unless Character.where(email_address:).none?
    end

    def username_uniqueness_validation
      errors.add(:username, :uniqueness) unless Character.where(tag: username).none?
    end
end
