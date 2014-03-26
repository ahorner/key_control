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
    end

    # Public: Add the requested data to the keychain for the given description.
    #
    # name - The description of the data.
    # data - The data to store in the keychain.
    #
    # Returns nothing.
    def []=(name, data)
      execute :add, "user", name, "\"#{data}\"", @keyring
    end

    # Public: Get the data matching the passed description from the keychain.
    #
    # name - The description of the data for which to search.
    #
    # Returns the requested data or nil.
    def [](name)
      result = execute :search, @keyring, "user", name
      execute :read, result if result
    end

    private

    # Private: Execute the requested action in keyctl.
    #
    # action - The keyctl action to perform.
    # args   - A list of arguments which should be passed to the action.
    #
    # Returns the stdout value returned by the call.
    def execute(action, *args)
      command = [action, *args].join(" ")
      `keyctl #{command}`
    end
  end
end
