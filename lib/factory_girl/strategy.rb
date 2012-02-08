require "active_support/core_ext/hash/except"
require "factory_girl/strategy/build"
require "factory_girl/strategy/create"
require "factory_girl/strategy/attributes_for"
require "factory_girl/strategy/stub"
require "observer"

module FactoryGirl
  class Strategy #:nodoc:
    include Observable

    # Generates an association using the current build strategy.
    #
    # Arguments:
    #   name: (Symbol)
    #     The name of the factory that should be used to generate this
    #     association.
    #   attributes: (Hash)
    #     A hash of attributes that should be overridden for this association.
    #
    # Returns:
    #   The generated association for the current build strategy. Note that
    #   associations are not generated for the attributes_for strategy. Returns
    #   nil in this case.
    #
    # Example:
    #
    #   factory :user do
    #     # ...
    #   end
    #
    #   factory :post do
    #     # ...
    #     author { |post| post.association(:user, :name => 'Joe') }
    #   end
    #
    #   # Builds (but doesn't save) a Post and a User
    #   FactoryGirl.build(:post)
    #
    #   # Builds and saves a User, builds a Post, assigns the User to the
    #   # author association, and saves the Post.
    #   FactoryGirl.create(:post)
    #
    def association(runner, overrides)
      raise NotImplementedError, "Strategies must return an association"
    end

    def result(attribute_assigner, to_create)
      raise NotImplementedError, "Strategies must return a result"
    end

    def self.ensure_strategy_exists!(strategy)
      unless Strategy.const_defined? strategy.to_s.camelize
        raise ArgumentError, "Unknown strategy: #{strategy}"
      end
    end

    private

    def run_callbacks(name, result_instance)
      changed
      notify_observers(name, result_instance)
    end
  end
end
