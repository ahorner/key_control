module KeyControl

  class Thread

    KEYRING = "@t"

    # Public: Add the requested data to the keychain for the given description.
    #
    # name - The description of the data.
    # data - The data to store in the keychain.
    #
    # Returns nothing.
    def []=(name, data)
      execute :add, "user", name, "\"#{data}\"", self.class.KEYRING
    end

    # Public: Get the data matching the passed description from the keychain.
    #
    # name - The description of the data for which to search.
    #
    # Returns the requested data or nil.
    def [](name)
      result = execute :search, self.class.KEYRING, "user", name
      execute :read, result if result
    end

    private

    # Private: Execute the requested action in keyctl.
    def execute(action, *args)
      command = [action, *args].join(" ")
      `keyctl #{command}`
    end
  end
end
