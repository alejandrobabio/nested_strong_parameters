# coding: utf-8
require 'test_helper'
require 'active_record'

class Parent < ActiveRecord::Base
  include NestedStrongParameters
  strong_fields :name, :child_attributes
end

class Child < ActiveRecord::Base
  include NestedStrongParameters
  strong_fields :name, :age, :toys_attributes
end

class Toy < ActiveRecord::Base
  include NestedStrongParameters
  strong_fields :name, :tag
  strong_fields :price, as: :admin
end

describe NestedStrongParameters do

  it 'admin whitelist' do
    toys_attributes = [:name, :tag, :price]
    child_attributes = [:name, :age, toys_attributes: toys_attributes]

    Parent.whitelist(:admin).must_equal [
      :name, { child_attributes: child_attributes }
    ]
  end

  it 'default whitelist' do
    toys_attributes = [:name, :tag]
    child_attributes = [:name, :age, toys_attributes: toys_attributes]

    Parent.whitelist.must_equal [
      :name, { child_attributes: child_attributes }
    ]
  end

  it 'admin whitelist without nested attributes' do
    Toy.whitelist(:admin).must_equal [:name, :tag, :price]
  end

  it 'role without strong_fields equal default whitelist' do
    Parent.whitelist.must_equal Parent.whitelist(:undefined_role)
  end
end
