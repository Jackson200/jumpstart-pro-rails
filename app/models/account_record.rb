class AccountRecord < ActiveRecord::Base
  self.abstract_class = true

  default_scope -> {
    if ActsAsTenant.configuration.require_tenant && ActsAsTenant.current_tenant.nil? && !ActsAsTenant.unscoped?
      raise ActsAsTenant::Errors::NoTenantSet
    end

    if ActsAsTenant.current_tenant
      keys = [ActsAsTenant.current_tenant.send(pkey)]
      keys.push(nil) if options[:has_global_records]

      query_criteria = {fkey.to_sym => keys}
      query_criteria[polymorphic_type.to_sym] = ActsAsTenant.current_tenant.class.to_s if options[:polymorphic]
      where(query_criteria)
    else
      ActiveRecord::VERSION::MAJOR < 4 ? scoped : all
    end
  }
end
