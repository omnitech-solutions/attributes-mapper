# frozen_string_literal: true

require 'rordash'
require 'json-path/builder'
require 'json-path/default_data_wrapper'
require 'json-path/path_context'
require 'json-path/path_context_collection'

%w[
  version
  configuration
  has_attributes
  builder
].each do |filename|
  require File.expand_path("../attributes-mapper/#{filename}", Pathname.new(__FILE__).realpath)
end

module AttributesMapper; end
