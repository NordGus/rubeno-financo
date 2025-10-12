# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :archive, inverse_of: :accounts
  belongs_to :parent, optional: true, class_name: "Account", foreign_key: :parent_id

  has_many :children, class_name: "Account", foreign_key: :parent_id, dependent: :destroy
end
