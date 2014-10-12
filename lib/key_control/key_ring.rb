module KeyControl

  class KeyRing

    attr_reader :system

    # Public: Get a new KeyControl::KeyRing instance with the specified keyring
    # identifier.
    #
    # keyring - A String or Integer identifying the desired keyring.
    #
    # Returns a KeyControl::KeyRing instance.
    def initialize(keyring)
      @keyring = keyring
      @system = System.new
    end

    # Public: Add the requested data to the keychain for the given description.
    #
    # name - The description of the data.
    # data - The data to store in the keychain.
    #
    # Returns nothing.
    def []=(name, data)
      system.run(:add, "user", name, data, data.length, @keyring)
    end

    # Public: Get the data matching the passed description from the keychain.
    #
    # name - The description of the data for which to search.
    #
    # Returns the requested data or nil.
    def [](name)
      handle = system.run(:search, "user", name, nil, @keyring)
      return nil if handle == -1

      system.get(:read, handle)
    end

    # Public: Unlink a key from the keychain.
    #
    # name - The description of the data to unlink.
    #
    # Returns nothing.
    def delete(name)
      handle = system.run(:search, "user", name, nil, @keyring)
      if handle == -1
        raise SystemCallError.new("search #{name}", Fiddle.last_error)
      end

      error = system.run(:unlink, handle, @keyring)
      if error == -1
        raise SystemCallError.new("unlink #{name}", FFI.errno)
      end
    end

    # Public: Set the timeout for the passed description.
    #
    # name    - The description of the data for which to set the timeout.
    # timeout - The timeout to set in seconds.
    #
    # Returns nothing.
    def set_timeout(name, timeout)
      handle = system.run(:search, "user", name, nil, @keyring)
      if handle == -1
        raise SystemCallError.new("search #{name}", Fiddle.last_error)
      end

      error = system.run(:set_timeout, handle, timeout)
      if handle == -1
        raise SystemCallError.new("set_timeout #{name}", Fiddle.last_error)
      end
    end
  end
end
