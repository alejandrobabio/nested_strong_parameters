require "nested_strong_parameters/version"
require "nested_strong_parameters/nested_strong_parameters"

require "active_record"
ActiveRecord::Base.include(NestedStrongParameters)
