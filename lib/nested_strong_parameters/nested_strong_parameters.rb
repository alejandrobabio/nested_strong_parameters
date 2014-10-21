require "active_support/concern"
require "active_support/core_ext"

module NestedStrongParameters
  extend ActiveSupport::Concern

  included do
    class_attribute :_strong_fields, instance_accessors: false
    self._strong_fields ||= {}
  end

  module ClassMethods
    def strong_fields(*args)
      options = extract_option_as(args)
      roles = options[:as] || :default

      self._strong_fields = self._strong_fields.deep_dup
      Array(roles).each do |role|
        self._strong_fields[role] ||= []
        self._strong_fields[role] += args
      end
    end

    def whitelist(role = nil)
      map_params(self, role)
    end

  private

    def extract_option_as(args)
      if args.last.is_a?(Hash) && args.last[:as]
        args.pop
      else
        {}
      end
    end

    def map_params(model, role = nil)
      fields = model._strong_fields[:default]
      fields += model._strong_fields.fetch(role) { [] }

      fields.uniq.map do |field|
        if field.to_s.match /_attributes$/
          { field => map_params(nested_model(field), role) }
        else
          field
        end
      end
    end

    def nested_model(field)
      field.to_s.gsub(/_attributes$/, '').classify.constantize
    end
  end
end
