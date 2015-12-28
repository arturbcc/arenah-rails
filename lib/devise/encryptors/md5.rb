require 'digest/md5'
require 'base64'

module Devise
  module Encryptable
    module Encryptors
      class Md5 < Base
        def self.digest(password, stretches, salt, pepper)
          str = Digest::MD5.digest(password.encode('UTF-8'))
          Base64.encode64(str)
        end
      end
    end
  end
end
