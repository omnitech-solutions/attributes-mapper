module AttributesMapper
  class Builder
    include HasAttributes

    attr_reader :input

    def initialize(input)
      transformed_input = if configuration.apply_input_data_transform?
                            configuration.apply_input_data_transform_proc.call(input)
                          else
                            input
                          end

      @input = Rordash::HashUtil.deep_symbolize_keys(transformed_input)
      @mapped_input = {}
    end

    def build
      @mapped_input = paths_builder.build_for(input).deep_symbolize_keys
      self
    end

    def to_h
      @mapped_input
    end

    def paths_builder
      @paths_builder ||= begin
        builder = JsonPath::Builder.new
        if configuration.source_data_wrapper_class?
          builder.with_wrapped_data_class(configuration.source_data_wrapper_class)
        end
        add_paths_to_builder(builder)
        builder
      end
    end

    private

    def add_paths_to_builder(builder)
      self.class.each_path_context_key_value_pair do |to, path_attrs|
        params = path_attrs.merge(to: to)

        if params.key?(SCOPE)
          scope_path = self.class.find_path_by_scope_name(params[SCOPE])
          builder.within(scope_path) { add_path_to_builder(builder, params) }
        else
          add_path_to_builder(builder, params)
        end
      end
    end

    def add_path_to_builder(builder, path_params)
      builder.from(path_params[:from], **path_params.except(:from, SCOPE))
    end

    def method_missing(method_name, *arguments, &block)
      return @mapped_input[method_name] if @mapped_input.key?(method_name)

      super
    end

    def respond_to_missing?(method_name, include_private = false)
      @mapped_input.key?(method_name) || super
    end
  end
end
