require "minitest/autorun"
require "minitest/mock"
require "key_control"

if RUBY_PLATFORM !~ /linux/
  raise "The test suite must be run on Linux"
elsif
  system("/sbin/ldconfig -p | grep -i libkeyutils.so > /dev/null 2>&1") ||
    raise("libkeyutils is not available")
end
