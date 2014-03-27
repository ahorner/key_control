require "fiddle"

module KeyControl

  class System

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

    def search
      @search ||= Fiddle::Function.new(
        keyutils["request_key"],
        [ Fiddle::ALIGN_CHAR,
          Fiddle::ALIGN_CHAR,
          Fiddle::ALIGN_CHAR,
          Fiddle::TYPE_INT ],
        Fiddle::TYPE_INT )
    end

    def read
      @read ||= Fiddle::Function.new(
        keyutils["keyctl_read"],
        [ Fiddle::TYPE_INT,
          Fiddle::ALIGN_CHAR,
          Fiddle::TYPE_SIZE_T ],
        Fiddle::TYPE_LONG )
    end

    private

    def keyutils
      @keyutils ||= Fiddle::Handle.new("/lib64/libkeyutils.so.1.3")
    end
  end
end
