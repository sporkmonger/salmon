require 'salmon'

module Salmon
  class Key
    MAGIC_KEY_PATTERN = /^RSA\.([a-zA-Z0-9_-]+)\.([a-zA-Z0-9_-]+)$/

    def initialize(modulus, exponent)
      @modulus = modulus
      @exponent = exponent
    end

    attr_reader :modulus
    attr_reader :exponent

    def to_s
      return (
        "RSA.#{Salmon.i_to_base64url(modulus)}." +
        "#{Salmon.i_to_base64url(exponent)}"
      )
    end

    def self.parse_magic_key(data)
      modulus, exponent = data.match(MAGIC_KEY_PATTERN)[1..2]
      Salmon::Key.new(
        Salmon.base64url_to_i(modulus),
        Salmon.base64url_to_i(exponent)
      )
    end
  end
end
