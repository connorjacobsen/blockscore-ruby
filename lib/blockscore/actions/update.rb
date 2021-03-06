module BlockScore
  module Actions
    # Public: Contains the :save instance method, which updates the
    # object with the BlockScore API to persist the changes.
    #
    # Examples
    #
    #  class Foo
    #    include BlockScore::Actions::Update
    #  end
    #
    #  foo = Foo.new
    #  foo.name_first = 'John'
    #  foo.save
    #  # => true
    module Update
      extend Forwardable

      # Attributes which will not change once the object is created.
      PERSISTENT_ATTRIBUTES = [
        :id,
        :object,
        :created_at,
        :updated_at,
        :livemode
      ]

      def_delegators 'self.class', :endpoint, :patch

      def save!
        if persisted?
          patch("#{endpoint}/#{id}", filter_params)
          true
        else
          super
        end
      end

      # Filters out the non-updateable params.
      def filter_params
        # Cannot %i syntax, not introduced until Ruby 2.0.0
        attributes.reject { |key, _| PERSISTENT_ATTRIBUTES.include?(key) }
      end
    end
  end
end
