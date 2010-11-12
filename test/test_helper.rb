require 'rubygems'
require 'bundler'

Bundler.setup

require 'test/unit'
require 'mocha'

require 'active_model'
require 'active_record'
require 'action_controller'

$:.unshift File.expand_path("../../lib", __FILE__)
require 'findable_by'
require 'connection/native_sqlite3/in_memory_connection'

