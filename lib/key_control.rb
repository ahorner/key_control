require "key_control/version"
require "key_control/system"
require "key_control/key_ring"

module KeyControl

  # Constants for special keyring identifiers. For more information, see:
  # http://manpages.ubuntu.com/manpages/oneiric/man1/keyctl.1.html
  THREAD  = -1
  PROCESS = -2
  SESSION = -3
  USER    = -4
  DEFAULT = -5
  GROUP   = -6

  # A list of potential library paths. Currently looks for the default shared
  # libraries on CentOS installations.
  LIBRARIES = %w(
    libkeyutils.so
    libkeyutils.so.1 )

  # Public: Shared library names.
  #
  # Returns an Array.
  def self.library_names
    LIBRARIES
  end

  # Public: Is a libkeyutils shared library detected on this system?
  #
  # Returns a boolean.
  def self.available?
    library_names.any? do |library_name|
      begin
        Fiddle::Handle.new(library_name)
      rescue Fiddle::DLError
        false
      end
    end
  end
end
