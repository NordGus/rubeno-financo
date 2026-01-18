# frozen_string_literal: true

##
# Account::System module represents the group of system account use for automation, internal flows, data labeling and/or
# any other use used by financo that the user does not support.
module Account::System
  def self.table_name_prefix
    "account_system_"
  end
end
