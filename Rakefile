
desc "`rake` will default to running `rake:run`"
task :default => :run

desc "Run all the rspec examples"
task :spec do
  system "bundle exec rspec -c spec/*_spec.rb"
end

desc "run the app"
task :run do
  system "ruby lib/app.rb"
end

