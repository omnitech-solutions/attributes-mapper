# frozen_string_literal: true

require 'json-path/builder'

%w[
  version
].each do |filename|
  require File.expand_path("../attributes-mapper/#{filename}", Pathname.new(__FILE__).realpath)
end



module AttributesMapper; end
