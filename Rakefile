# Encoding: utf-8

require 'cucumber'
require 'cucumber/rake/task'

task :clean do
  rm_f 'report.json'
  rm_rf 'report'
  rm_f Dir.glob('*.png')
  rm_f 'tmp_store.yml'
end


Cucumber::Rake::Task.new(:smoke) do |t|
  t.cucumber_opts = '-x --tags @smoke'
end

task default: :smoke
