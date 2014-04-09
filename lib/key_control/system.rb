require "fiddle"

module KeyControl

  class System

    # Public: Execute the requested action in keyctl.
    #
    # action - The action to perform.
    # args   - A list of arguments which should be passed to the action.
    #
    # Returns the stdout value returned by the call.
    def run(action, *args)
      send(action).call(*args)
    end

    # Public: Execute the requested keyctl action, buffering the output into a
    # string in multiple passes.
    #
    # action - The action to perform.
    # args   - A list of arguments which should be passed to the action.
    #
    # Returns a String containing the buffered output.
    def get(action, *args)
      length = run(action, *args, "", 0)
      buffer = "\x00" * length
      run(action, *args, buffer, length)

      buffer
    end

    # Public: Get a symbol representing the reason for the last error set by a
    # system call.
    #
    # Returns a Symbol or nil.
    def error
      Errno.constants.detect do |error_name|
        errno = Errno.const_get(error_name)
        errno::Errno == Fiddle.last_error
      end
    end

    private

    # Private: Get a handle representing the system calls available through
    # libkeyutils.so.
    #
    # Returns a Fiddle::Handle.
    def keyutils
      @keyutils ||= KeyControl::LIBRARIES.detect do |library|
        begin
          break Fiddle::Handle.new(library)
        rescue Fiddle::DLError
          nil
        end
      end
    end

    # Private: Get a proc representing the add_key system call.
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

    # Private: Get a proc representing the request_key system call.
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

    # Private: Get a proc representing the keyctl_read system call.
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
  end
end
