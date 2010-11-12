# encoding: UTF-8
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require File.join(File.dirname(__FILE__), 'lib', 'findable_by', 'version')

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the findable_by plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the findable_by plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'FindableBy'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name        = "findable_by"
    s.version     = FindableBy::VERSION.dup
    s.summary     = "Improving a way how you find records!"
    s.email       = "thiago@moretto.eng.br"
    s.homepage    = "http://github.com/thiagomoretto/findable_by"
    s.description = "Even easier to find records!"
    s.authors     = ['Thiago Moretto']
    s.files       = FileList["[A-Z]*(.rdoc)", "{lib}/**/*", "init.rb"]
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install jeweler"
end
