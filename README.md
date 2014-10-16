# NestedStrongParameters

If in your Rails app you use strong_parameters with nested_attributes, and believe the old attr_accessible were easier to use. This gem is for you.

NestedStrongParameters make simple the use of nested_attributes with strong_parameters.

## Installation

Add this line to your application's Gemfile:

```ruby
  gem 'nested_strong_parameters'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nested_strong_parameters

## Usage

In your models use `strong_fields` to define the whitelist of fields that can be updated by params. If a model accepts nested attributes for `some_model`, add the field `<some_model>_attributes`. Also you can set a role with :as option, and works fine with STI. Yes, just like we used to do with protected_attributes.

```ruby
  Class Project < ActiveRecord::Base
    has_many :tasks

    accepts_nested_attributes_for :tasks

    strong_fields :name, :description, :tasks_attributes
    strong_fields :budget, as: :admin
  end

  Class Task < ActiveRecord::Base
    belongs_to :project

    strong_fields :name, :start, :end
  end
```

Now call permit on params is really easy:

```ruby
  # with Project.whitelist, I got:
  ~/ (main) > Project.whitelist
  => [:name, :description, {:tasks_attributes=>[:name, :start, :end]}]

  # or with admin role:
  ~/ (main) > Project.whitelist(:admin)
  => [:name, :description, {:tasks_attributes=>[:name, :start, :end]}, :budget]

  # used to call permit
  @project.update_attributes(params.permit(Project.whitelist))
```

Can I avoid error prone with whitelist? Take a look to this real life example:

```ruby
  # irb:
  ~/rails/rfinan (main) > Dealing.whitelist
  [:due_date,
  :note,
  :status,
  {:items_attributes=>
    [:amount,
      :dealing_id,
      :product_selector,
      :price,
      :sign,
      :reference_value,
      :chk_item,
      :sequence,
      {:security_items_attributes=>
        [:commission,
        :commission_rate,
        :interest,
        :interest_rate,
        :net_value,
        :security_id,
        :item_id,
        :sequence,
        {:check_attributes=>
          [:amount,
            :note,
            :payment_day,
            :commodity_id,
            :owner,
            :branch,
            :number,
            :bank_lookup,
            :signer_lookup,
            :chk_refuse]},
        {:loan_attributes=>
          [:amount,
            :note,
            :payment_day,
            :commodity_id,
            :owner,
            :due_date,
            :params]}]},
      :payer_sequence,
      :paid_items_count]},
  {:person_attributes=>
    [:name,
      :phone,
      :mobile,
      :address,
      :city,
      :province,
      :estate,
      :postal_code,
      :email,
      :note]}]

  # controller code with nested_strong_parameters:
  Dealing.create(params.permit(Dealing.whitelist))
  # vs/ raw
  Dealing.create(params.permit([:due_date, :note, :status, {:items_attributes=>[:amount, :dealing_id, :product_selector, :price, :sign, :reference_value, :chk_item, :sequence, {:security_items_attributes=>[:commission, :commission_rate, :interest, :interest_rate, :net_value, :security_id, :item_id, :sequence, {:check_attributes=>[:amount, :note, :payment_day, :commodity_id, :owner, :branch, :number, :bank_lookup, :signer_lookup, :chk_refuse]}, {:loan_attributes=>[:amount, :note, :payment_day, :commodity_id, :owner, :due_date, :params]}]}, :payer_sequence, :paid_items_count]}, {:person_attributes=>[:name, :phone, :mobile, :address, :city, :province, :estate, :postal_code, :email, :note]}]))

```

## Contributing

1. Fork it ( https://github.com/alejandrobabio/nested_strong_parameters/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
