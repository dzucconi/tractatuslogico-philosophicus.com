require "rubygems"
require "bundler"

Bundler.require

# Dir["#{File.dirname(__FILE__)}/app/**/*.rb"].each { |f| load(f) }
require "./application"

run Application
