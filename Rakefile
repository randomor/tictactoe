require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.libs.push "test"
  t.test_files = FileList['test/lib/*_test.rb']
  t.verbose = false
end

task :default => :test
