# frozen_string_literal: true

class Character::CreateForm < ApplicationForm
  has_secure_password

  define_model_callbacks :initialize, only: [ :after ]

  attribute :username, :string
  attribute :email_address, :string
  attribute :password_digest, :string

  validates :username, presence: true, length: { maximum: 256 }
  validates :email_address, presence: true, email: true

  validate :email_address_uniqueness_validation
  validate :username_uniqueness_validation

  after_initialize :normalize_email_address
  after_initialize :normalize_tag

  def self.model_name
    ActiveModel::Name.new(self, nil, "Character")
  end

  def new_record?
    true
  end

  private

    def email_address_uniqueness_validation
      errors.add(:email_address, :uniqueness) unless Character.where(email_address:).none?
    end

    def username_uniqueness_validation
      errors.add(:username, :uniqueness) unless Character.where(tag: username).none?
    end

    def normalize_email_address
      self.email_address = email_address.strip.downcase if email_address.present?
    end

    def normalize_username
      self.username = username.strip.gsub(/\s+/, "") if username.present?
    end
end
