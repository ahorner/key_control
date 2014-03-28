require "fiddle"

module KeyControl

  class System

    # Public: Get a proc representing the add_key system call.
    #
    # Returns a Fiddle::Function.
    def add
      @add ||= Fiddle::Function.new(
        keyutils["add_key"],
        [ Fiddle::ALIGN_CHAR,
          Fiddle::ALIGN_CHAR,
          Fiddle::TYPE_VOIDP,
          Fiddle::TYPE_SIZE_T,
          Fiddle::TYPE_INT ],
        Fiddle::TYPE_INT )
    end

    # Public: Get a proc representing the request_key system call.
    #
    # Returns a Fiddle::Function.
    def search
      @search ||= Fiddle::Function.new(
        keyutils["request_key"],
        [ Fiddle::ALIGN_CHAR,
          Fiddle::ALIGN_CHAR,
          Fiddle::ALIGN_CHAR,
          Fiddle::TYPE_INT ],
        Fiddle::TYPE_INT )
    end

    # Public: Get a proc representing the keyctl_read system call.
    #
    # Returns a Fiddle::Function.
    def read
      @read ||= Fiddle::Function.new(
        keyutils["keyctl_read"],
        [ Fiddle::TYPE_INT,
          Fiddle::ALIGN_CHAR,
          Fiddle::TYPE_SIZE_T ],
        Fiddle::TYPE_LONG )
    end

    private

    # Private: Get a handle representing the system calls available through
    # libkeyutils.so.
    #
    # Returns a Fiddle::Handle.
    def keyutils
      @keyutils ||= KeyControl::LIBRARIES.map do |library|
        begin
          Fiddle::Handle.new(library)
        rescue Fiddle::DLError
          nil
        end
      end.compact.first
    end
  end
end
