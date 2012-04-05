module Searchlogic
  module ActiveRecord
    # The internals to ActiveRecord like to do scopes.include?(scope_name). And this is how they check for the existence
    # of scopes, which is terrible. The problem is that searchlogic scopes are dynamically created. So the only solution
    # is to override the include? method for the scopes hash, try to create the named scope, and then check it again.
    # This shouldn't effect performance because once its created it never gets called again. I also cache failed names
    # so we don't try to create them again.
    module Scope
      def scopes
        read_inheritable_attribute(:scopes) || write_inheritable_attribute(:scopes, {}.tap do |h|
          h.instance_eval <<-eval
            def include?(key)
              result = super
              return result if result
              #{name}.respond_to?(key)
              super
            end
          eval
        end)
      end
    end
  end
end