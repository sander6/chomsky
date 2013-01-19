test_dir = File.dirname(__FILE__)
$:.unshift File.expand_path(File.join(test_dir, "..", "lib"))
$:.unshift File.expand_path(test_dir)

Dir.chdir(test_dir) { Dir["**/*_test.rb"].each { |file| require file } }
