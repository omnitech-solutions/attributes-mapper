# frozen_string_literal: true

require 'rordash'
require 'json-path/builder'

%w[
  version
  configuration
  has_attributes
].each do |filename|
  require File.expand_path("../attributes-mapper/#{filename}", Pathname.new(__FILE__).realpath)
end

module AttributesMapper; end
