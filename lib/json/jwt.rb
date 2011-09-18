require 'openssl'
require 'url_safe_base64'
require 'json'

module JSON
  class JWT < Hash
    attr_accessor :header, :signature

    def initialize(claims)
      @header = {
        :typ => :JWT,
        :alg => :none
      }
      [:exp, :nbf, :iat].each do |key|
        if claims[key]
          claims[key] = claims[key].to_i
        end
      end
      replace claims
    end

    def sign(private_key_or_secret, algorithm = :RS256)
      JWS.new(self).sign(private_key_or_secret, algorithm)
    end

    def to_s
      [
        header.to_json,
        self.to_json,
        signature
      ].collect do |segment|
        UrlSafeBase64.encode64 segment.to_s
      end.join('.')
    end
  end
end

require 'json/jws'
require 'json/jwe'