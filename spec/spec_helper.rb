$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'
require 'coveralls'
require 'keynote-client'

Bundler.setup(:default, :development)

RSpec.configure do |config|
  config.color = true
  config.tty = true
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start do
 add_filter '/spec/'
end
