require 'salmon'
require 'openssl'

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

    def to_pem
      return self.to_openssl.to_pem
    end

    def to_der
      return self.to_openssl.to_der
    end

    def to_openssl
      @openssl_key ||= (begin
        key = OpenSSL::PKey::RSA.new
        key.n = self.modulus
        key.e = self.exponent
        key
      end)
      return @openssl_key
    end

    def self.parse_magic_key(data)
      modulus, exponent = data.match(MAGIC_KEY_PATTERN)[1..2]
      return Salmon::Key.new(
        Salmon.base64url_to_i(modulus),
        Salmon.base64url_to_i(exponent)
      )
    end

    def self.parse_pem(data)
      openssl_key = OpenSSL::PKey::RSA.new(data)
      return Salmon::Key.new(openssl_key.n, openssl_key.e)
    end
    class <<self
      alias_method :parse_der, :parse_pem
    end
  end
end
