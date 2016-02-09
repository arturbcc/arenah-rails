# FIXME: remove this and all calls to this concern
# module Tokenable
#   extend ActiveSupport::Concern
#
#   included do
#     before_create :generate_token
#
#     attribute :token, :string
#   end
#
#   protected
#
#   def generate_token
#     self.token = SecureRandom.urlsafe_base64(nil, false)
#   end
# end
