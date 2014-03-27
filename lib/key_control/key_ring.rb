module KeyControl

  class KeyRing

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
      execute(:add, "user", name, data, data.length, @keyring)
    end

    # Public: Get the data matching the passed description from the keychain.
    #
    # name - The description of the data for which to search.
    #
    # Returns the requested data or nil.
    def [](name)
      handle = execute(:search, "user", name, nil, @keyring)
      return nil if handle == -1

      length = execute(:read, handle, "", 0)
      buffer = "0" * length
      execute(:read, handle, buffer, length)

      buffer
    end

    private

    # Private: Execute the requested action in keyctl.
    #
    # action - The action to perform.
    # args   - A list of arguments which should be passed to the action.
    #
    # Returns the stdout value returned by the call.
    def execute(action, *args)
      @system.send(action).call(*args)
    end
  end
end
