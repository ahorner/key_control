require "key_control/version"
require "key_control/key_ring"

module KeyControl

  SESSION = "@s"
  USER    = "@u"
  DEFAULT = "@us"
  GROUP   = "@g"

  # Thread and Process-level keyrings won't work for the time being, due to the
  # fact that calls to keyctl have to happen through a subshell. These are here
  # for the sake of documentation.
  THREAD  = "@t"
  PROCESS = "@p"
end
