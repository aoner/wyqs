require 'wyqs/consumer'
module Wyqs
  class << self
    attr_accessor :appid, :app_secret, :site
  end

  autoload :Consumer, "taobao/consumer"
end
