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

    # Public: Remove the data matching the passed description from the keychain.
    #
    # name - The description of the data to remove.
    #
    # Returns nothing.
    def delete(name)
      handle = system.run!(:search, "user", name, nil, @keyring)
      system.run!(:unlink, handle, @keyring)
    end

    # Public: Set a timeout for the data matching the passed description.
    #
    # name    - The description of the data for which to set a timeout.
    # timeout - The timeout to set in seconds.
    #
    # Returns nothing.
    def set_timeout(name, timeout)
      handle = system.run!(:search, "user", name, nil, @keyring)
      system.run!(:set_timeout, handle, timeout)
    end
  end
end
