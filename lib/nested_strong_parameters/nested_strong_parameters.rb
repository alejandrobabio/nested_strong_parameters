require "active_support/concern"

module NestedStrongParameters
  extend ActiveSupport::Concern

  included do
    class_attribute :_strong_fields, instance_accessors: false
    self._strong_fields ||= {}
  end

  module ClassMethods
    def strong_fields(*args)
      options = args.extract_options!
      roles = options[:as] || :default

      Array(roles).each do |role|
        self._strong_fields[role] ||= []
        self._strong_fields[role] += args
      end
    end

    def whitelist(role = nil)
      map_params(self, role)
    end

  private

    def map_params(model, role = nil)
      fields = model._strong_fields[:default]
      fields += model._strong_fields.fetch(role) { [] }
      fields.uniq!

      fields.map do |field|
        if field.to_s.match /_attributes$/
          {
            field => map_params(
              field.to_s.gsub(/_attributes$/, '').classify.constantize, role
            )
          }
        else
          field
        end
      end
    end
  end
end
