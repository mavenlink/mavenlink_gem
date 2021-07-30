module Mavenlink
  class User < Model
    def association_load_filters
      filters = { show_disabled: true }
      return filters if account_id != client.me.account_id

      filters.merge(on_my_account: true)
    end
  end
end
