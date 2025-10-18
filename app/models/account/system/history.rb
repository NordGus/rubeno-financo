# frozen_string_literal: true

class Account::System::History < Account
  belongs_to :parent, class_name: "Account", foreign_key: :parent_id
end
