# KeyControl

KeyControl is a Ruby wrapper for the `keyctl` commands available on most Linux
systems. It provides a Hash-like API for storing and retrieving data using the
kernel's built-in key management facilities.

## Installation

Add this line to your application's Gemfile:

    gem 'key_control'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install key_control

## Usage

### Availability

You can check if `KeyControl` is supported on your system with
`KeyControl.available?`. This will attempt to locate a libkeyutils shared
library on the system, and return a boolean based on detection.

### Key Storage/Retrieval

The basic API consists of a single class, `KeyControl::KeyRing`. The `KeyRing`
initializer takes a single argument, the ID of the keyring you wish to store
your data in. There are several (very useful) [special keyrings](http://manpages.ubuntu.com/manpages/oneiric/man1/keyctl.1.html),
which are available for use as constants in the `KeyControl` module.

As an example, we'll create a basic accessor for the session keyring (useful
for sharing information among several grouped processes):
```ruby
keyring = KeyControl::KeyRing.new(KeyControl::SESSION)
```

Once you have your keyring instance, just add and fetch values like you would
with any regular Hash:
```ruby
keyring["mykey"] = "my passphrase"
keyring["mykey"]
# => "my passphrase"
```

That's it! The power of this gem is the ability to use your kernel's built-in
key management mechanism to share information between Ruby processes,
without exposing your data to the outside world.

### Key Deletion/Expiration

There are two options to remove values from the current keyring. You can
remove a piece of data immediately with `KeyRing#delete`:
```ruby
keyring.delete("mykey")
keyring["mykey"]
# => nil
```

Alternately, if you need temporary access to the key, but want to ensure that
it will be removed from the keyring at some point in the future,
`KeyRing#set_timeout` is available:
```ruby
keyring.set_timeout("mykey", 3)
keyring["mykey"]
# => "my passphrase"
sleep 4
keyring["mykey"]
# => nil
```

## Contributing

1. Fork it ( http://github.com/ahorner/key_control/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### Thanks

- @gabrielg: For refactoring the library detection, and setting up a slick
  vagrant test suite.
- @qfire: For contributing the handy `unlink` and `set_timeout` operations.
