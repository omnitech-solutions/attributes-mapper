module AttributesMapper
  class Configuration
    include ActiveSupport::Configurable

    config_accessor(:required_attributes) { [] }
    config_accessor(:optional_attributes) { [] }
    config_accessor(:scopes) { {} }
    config_accessor(:source_data_wrapper_class) { nil }
    config_accessor(:apply_input_data_transform_proc) { nil }

    def ordered_path_context_names
      required_attributes + optional_attributes
    end

    def source_data_wrapper_class?
      source_data_wrapper_class.present?
    end

    def apply_input_data_transform?
      apply_input_data_transform_proc.is_a?(Proc)
    end
  end
end
