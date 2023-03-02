module AttributesMapper
  module HasAttributes
    extend ActiveSupport::Concern

    SCOPE = :scope

    ALLOWED_PARAMETERS = [
      :from,
      :transform,
      :fallback,
      :skip_if,
      SCOPE
    ].freeze

    # rubocop:disable Metrics/BlockLength
    class_methods do
      attr_writer :path_context_attr_list_map

      delegate :required_attributes, :optional_attributes, :ordered_path_context_names, to: :configuration

      def path_context_attr_list_map
        @path_context_attr_list_map ||= {}
      end

      def path_context_params_for(key)
        path_context_attr_list_map[key.to_sym]
      end

      def each_path_context_key_value_pair(&block)
        path_context_attr_list_map.slice(*configuration.ordered_path_context_names).each_pair(&block)
      end

      def add_path_context_attrs(key, **path_context_args)
        path_context_attr_list_map[key] = path_context_args

        self
      end

      def find_path_by_scope_name(name)
        path_scopes[name.to_sym]
      end

      def define_attribute_methods
        configuration.ordered_path_context_names.each { |name| define_attribute_method(name) }
      end

      def define_attribute_method(name)
        singleton_class.send(:define_method, name) do |&block|
          params = block.call
          raise "block must return valid hash path params" unless params.is_a?(Hash)

          apply_attribute(name, params.slice(*(ALLOWED_PARAMETERS + [SCOPE])))
        end
      end

      def apply_attribute(name, **params)
        add_path_context_attrs(name, **params)
        nil
      end

      private

      def path_scopes
        @path_scopes ||= configuration.scopes.symbolize_keys
      end
    end
    # rubocop:enable Metrics/BlockLength

    module ConfigurationMethods
      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        yield configuration
        define_attribute_methods
      end
    end

    module ConfigurationInstanceMethods
      delegate :config, to: :configuration

      def configuration
        self.class.configuration
      end
    end

    def self.included(base)
      base.singleton_class.include(ConfigurationMethods)
      base.include(ConfigurationInstanceMethods)
    end
  end
end
