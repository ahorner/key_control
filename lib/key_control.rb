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

  # A list of potential library paths. Currently points to the default path for
  # CentOS installations.
  # TODO: Track down and add the default library paths for more distros.
  LIBRARIES = %w(
    /lib64/libkeyutils.so.1 )

  # Public: Does KeyControl detect any known keyutils libraries?
  #
  # Returns a boolean.
  def self.available?
    LIBRARIES.any? { |library| File.exists?(library) }
  end
end
