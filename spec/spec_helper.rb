require 'coveralls'
Coveralls.wear!

require 'support/vcr_setup'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'route_c'
require 'timecop'
require 'curacao'
