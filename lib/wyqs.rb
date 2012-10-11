require 'wyqs/token'
require 'wyqs/consumer'
module Wyqs
  class << self
    attr_accessor :appid, :app_secret
  end

  autoload :Token, "wyqs/token"
  autoload :Consumer, "wyqs/consumer"
end
